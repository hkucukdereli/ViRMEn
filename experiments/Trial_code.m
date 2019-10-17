function code = Trial_code
% Trial_code   Code for the ViRMEn experiment tennisCourt.
% code = Conditioning   Returns handles to the functions that ViRMEn
% executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT


% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr) 
    vr.session = struct('mouse', 'TP00',...
                        'date', '190924',...
                        'run', 1,...
                        'cueList', struct('stim', 'CueStripe90',... % stim or neutral
                                          'neutral','CueCheckers',... % stim
                                          'gray', 'CueGray'),...
                        'notes', '',...
                        'config','debug_cfg');

    vr.state = struct('onWait',true, 'onKey',false, 'onCam',false,...
                      'onStress',false, 'onPadding',false, 'onTrial',false,...
                      'onStim',false, 'onITI',false, 'onHabituation',false,...
                      'onBlackOut',false, 'onPlot',false, 'onDAQ',false);

    vr.sessionData = struct('startTime', 0, 'endTime', 0, 'trialNum', 1,...
                            'trialTime', [], 'stressTime', [],...
                            'position',[], 'velocity', [], 'timestamp', [],...
                            'stimon', [], 'stimoff', [], 'ition', [],...
                            'timeout',[], 'cuetype',[], 'cueid', [],...
                            'shockTime', [], 'shockCount', []);
    
    % check if the right cues are used
    if ~strcmp(vr.exper.userdata.experimentType, 'habituation')
        cuetypes = fields(vr.session.cueList);
        for c=1:length(cuetypes)
            cue = vr.session.cueList.(cell2mat(cuetypes(c)));
            if ~any(strcmp(cue, vr.exper.userdata.cuelist))
                error('%s is not a valid cue name. Wrong cue name is given for the %s cue.\n', cue, cell2mat(cuetypes(c)));
            end
        end
    end
    
    % load the variables from the config file
    vr = loadConfig(vr);
    
    % initilize save
    vr = initializeSave(vr);
    
    % initialize the serial
    vr = initializationForSerial(vr);
    
    % initialize plotting window
    vr = initializePlot(vr);
    
    % initialize the nidaq board
    vr = initializeDAQ(vr);
    
    % initialize shock count depending on the experiment
    if strcmp(vr.session.experiment, 'stress')
        vr.shockCount = 1;
        % set the shock times
        vr = initializeShocks(vr);
    elseif strcmp(vr.session.experiment, 'trial')
        vr.shockCount = 0;
    elseif strcmp(vr.session.experiment, 'habituation')
        vr.shockCount = 0;
    else
        warning("Wrong experiment type. Types to choose: trial, shock, stress.");
    end
    
    vr.startTime = 0;
    vr.endTime = 0;
    % vr.stressTime = 0;
    vr.paddingTime = 0;
    vr.stimTime = 0;
    
    vr.cueid = 0;
    vr.paddingCount = 0;
    
    vr.initPos = vr.worlds{vr.currentWorld}.startLocation;
    vr.lastPos = 0;
    vr.lastWorldPos = vr.initPos(2);
    % initialize the waiting period
    vr.lastWorld = vr.currentWorld;
    if strcmp(vr.session.experiment, 'stress')
        vr.currentWorld = vr.exper.userdata.nWorlds+1;
    end
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
    vr.waitOn = true;
    
    fprintf(['Press S to test the shock during the waiting period.\n',...
             'Press spacebar to start the experiment.\n']);
         
    
        
        
% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr) 
    % log the data
    vr = logData(vr);
    
    % plot the animal's position on the second window if necessary
    vr = vrPlot(vr);

    % wait starts
    if vr.state.onWait
        vr.position(2) = vr.initPos(2);
        % send out shocks if 'S' key is pressed
        if (vr.keyPressed == 83 || vr.keyPressed == 115)
            arduinoWriteMsg(vr.arduino_serial, 'PP');
        end
    end
    if vr.state.onWait && vr.keyPressed == 32
        % end wait and move to padding block
        vr.state.onWait = false;
        vr = startPadding(vr);
        fprintf('Experiment starts.\n');
    end
    % wait block ends
    
    % padding starts
    if vr.state.onPadding
        vr.position(2) = vr.initPos(2);
    end
    if vr.state.onPadding && vr.timeElapsed - vr.paddingTime >= vr.session.paddingDuration(vr.paddingCount)
        % end padding and move to the next block stress or trial
        vr.state.onPadding = false;
        
        if vr.paddingCount == 1
            % log the start time
            vr.startTime = vr.timeElapsed;
            vr.sessionData.startTime = vr.startTime;
    
            if strcmp(vr.session.experiment, 'trial')
                vr = startTrial(vr);  
            elseif strcmp(vr.session.experiment, 'habituation')
                vr = startHabituation(vr);
            elseif strcmp(vr.session.experiment, 'stress')
                vr = startStress(vr);
            end
        elseif vr.paddingCount == 2
            vr.experimentEnded = true;
        end
    end
    % padding block ends.
    
    % stress starts
    if vr.state.onStress
        vr = teleportCheck(vr);
        if vr.shockCount < length(vr.sessionData.stressShocks{vr.sessionData.trialNum}) && vr.timeElapsed - vr.sessionData.stressTime(end) > vr.sessionData.stressShocks{vr.sessionData.trialNum}(vr.shockCount)
            vr = badMouse(vr);
        end
        if vr.timeElapsed - vr.sessionData.stressTime(end) >= vr.session.stressDuration
            % end stress and move to trial block
            vr.state.onStress = false;
            vr.shockCount = 1; % reset the shock count
            vr = startTrial(vr);
        end
    end
    % stress block ends

    % trial start
    if vr.state.onTrial
        % see if time out is needed
        vr = checkTimeout(vr);

        % update the position and cue lists
        vr.positions = vr.exper.userdata.positions(vr.currentWorld,:);
        vr.cuelist = vr.exper.userdata.cues(vr.currentWorld,:);
        vr.cueids = vr.exper.userdata.cueids(vr.currentWorld,:);
        % find out which cue the position falls into
        vr = whichCue(vr);
        % only do something if the cue shas changed
        vr = selectCue(vr);
        % see if the position is at the start of the overlap
        vr = positionCheck(vr);
        
        % see if there will be another stress trial
        if vr.timeElapsed - vr.sessionData.trialTime(end) >= vr.session.trialDuration && vr.sessionData.trialNum <= vr.session.numTrials
            vr.state.onTrial = false;
            % remember which world an dposition we were
            vr.lastWorld = vr.currentWorld;
            vr.lastWorldPos = vr.position(2);
            % move to the next trial or next stress period
            if strcmp(vr.session.experiment, 'stress')
                vr = startStress(vr);
            else
                vr = startTrial(vr);
            end
        end
    
        % terminate the experiment if necessary
        if vr.timeElapsed - vr.sessionData.startTime >= vr.session.numTrials*(vr.session.trialDuration + vr.session.stressDuration)
            vr.state.onTrial = false;
            if vr.session.serial
                arduinoWriteMsg(vr.arduino_serial, 'O'); % terminate stim in case it was left on for whatever reason
                arduinoWriteMsg(vr.arduino_serial, 'C'); % disbale cam pulsing
            end
            vr.endTime = vr.timeElapsed;
            vr.sessionData.endTime = vr.timeElapsed;
            vr = startPadding(vr);
        end
    end
    % trial end
    
    % habituation starts
    if vr.state.onHabituation
        vr = teleportCheck(vr);
    end
    if vr.state.onHabituation && vr.timeElapsed - vr.sessionData.startTime >= vr.session.habituationDuration
        vr.state.onHabituation = false;
        vr.sessionData.endTime = vr.timeElapsed;
        vr = startPadding(vr);
    end
    % habituation block ends
   


    

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)  
    % log the time in case the user escaped
    if ~vr.endTime && vr.sessionData.startTime
        vr.sessionData.endTime = vr.timeElapsed;
        if ~strcmp(vr.session.experiment, 'habituation')
            % turn the stim off in case the user escaped and log it
            % vr = stimOff(vr);
        end
    end
    
    if vr.daq.state
        if strcmp(vr.daq.daqtype, 'analog')
            vr = terminateDAQ(vr);
            vr = saveDAQData(vr);
        end
    end
    
    vr.sessionData.stimoff = reshape(vr.sessionData.stimoff, 2, []);
    vr.sessionData.stimon = reshape(vr.sessionData.stimon, 2, []);
    vr.sessionData.ition = reshape(vr.sessionData.ition, 2, []);
    vr.sessionData.timeout = reshape(vr.sessionData.timeout, 2, []);
    
    daqData = vr.daq.data;
    sessionData = vr.sessionData;
    session = vr.session;
    
    if vr.session.save
        if vr.daq.state
            save(vr.savepath, 'session', 'sessionData', 'daqData');
        else
            save(vr.savepath, 'session', 'sessionData');
        end
    end
    
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, 'O'); % terminate stim in case it was left on for whatever reason
        arduinoWriteMsg(vr.arduino_serial, 'C'); % disbale cam pulsing
        terminationForSerial(vr);
    end
    