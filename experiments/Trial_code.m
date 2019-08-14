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
                        'date', '190805',...
                        'run', 1,...
                        'rewardsize', 600,...
                        'experiment', 'stress',... %'habituation' or 'trial' or 'stress'
                        'cueList', struct('stim', 'CueLightRect',... % stim, nostim or neutral
                                          'neutral','CueDarkCircle',... % stim, reward
                                          'gray', 'CueGray'),...
                        'notes', '',...
                        'config','debug_cfg');
    
    % load the variables from the config file
    vr = loadConfig(vr);

    vr.state = struct('onWait', true, 'onKey', false, 'onCam', false,...
                      'onStress', false, 'onPadding', false, 'onTrial', false,...
                      'onStim', false, 'onITI', false, 'onHabituation', false,...
                      'onBlackOut', false, 'onReward', false);

    vr.sessionData = struct('startTime', 0, 'endTime', 0, 'trialNum', 0,...
                            'trialTime', [], 'stressTime', [],...
                            'position',[], 'velocity', [], 'timestamp', [],...
                            'stimon', [], 'stimoff', [], 'ition', [],...
                            'timeout',[], 'cuetype',[], 'cueid', [],...
                            'shockTime', [], 'shockCount', [], 'stressShocks', [],...
                            'reward',[], 'rewardDelay', [], 'licks', []);
                        
    % initialize the serial
    if vr.session.serial
        serialFix;
        vr = initializationForSerial(vr);
    end
    
    % initialize shock count depending on the experiment
    if strcmp(vr.session.experiment, 'stress')
        vr.shockCount = 1;
        % determine the shock times
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
    
    if isfield(vr.exper.userdata, 'rewarddelay')
        vr.rewardDelay = vr.exper.userdata.rewarddelay; % sec
    else
        vr.rewardDelay = 0;
        fprintf('Reward delay is set to 0 seconds.\n');
    end
    
    fprintf(['Press S to test the shock during the waiting period.\n',...
             'Press spacebar to start the experiment.\n']);
    
        
        
% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

    vr = logData(vr);

    % wait starts
    if vr.state.onWait
        vr.position(2) = vr.initPos(2);
        if (vr.keyPressed == 83 | vr.keyPressed == 115)
            arduinoWriteMsg(vr.arduino_serial, 'PP');
        end
    end
    if vr.state.onWait & vr.keyPressed == 32
        % log the start time
        vr.startTime = vr.timeElapsed;
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
    if vr.state.onPadding & vr.timeElapsed - vr.startTime >= vr.session.paddingDuration
        % log the start time
        vr.startTime = vr.timeElapsed;
        % end padding and move to the next block stress or trial
        vr.state.onPadding = false;
        
        if vr.paddingCount == 1
            if strcmp(vr.session.experiment, 'trial')
                vr.sessionData.startTime = vr.startTime;
                vr = startTrial(vr);
                fprintf('Trial starts.\n');
            elseif strcmp(vr.session.experiment, 'habituation')
                vr.sessionData.startTime = vr.startTime;
                vr = startHabituation(vr);
            elseif strcmp(vr.session.experiment, 'stress')
                vr.sessionData.startTime = vr.startTime;
                vr = startStress(vr);
                fprintf('Stress period starts.\n');
            end
        elseif vr.paddingCount == 2
            vr.experimentEnded = true;
        end
    end
    % padding block ends.
    
    % stress starts
    if vr.state.onStress
        vr = teleportCheck(vr);
        
        if vr.shockCount < length(vr.sessionData.stressShocks) && vr.timeElapsed - vr.sessionData.stressTime(end) > vr.sessionData.stressShocks(vr.shockCount)
            vr = badMouse(vr);
            display(vr.shockCount);
            vr.shockCount = vr.shockCount + 1;
        end
        if vr.timeElapsed - vr.sessionData.stressTime(end) >= vr.session.stressDuration
            % end stress and move to trial block
            vr.state.onStress = false;
            vr = startTrial(vr);
            fprintf('Trial starts.\n'); 
        end
    end
    % stress block ends
    
    % trial start
    if vr.state.onTrial
        % see if there's reward to be given
        vr = rewardCheck(vr);
        % see if time out is needed
        vr = timeoutCheck(vr);
        % update the position and cue lists
        vr.positions = vr.exper.userdata.positions(vr.currentWorld,:);
        vr.cuelist = vr.exper.userdata.cues(vr.currentWorld,:);
        vr.cueids = vr.exper.userdata.cueids(vr.currentWorld,:);
        % find out which cue the position falls into
        vr = whichCue(vr);
        % only do something if the cue has changed
        vr = selectCue(vr);
        % see if the position is at the start of the overlap
        vr = positionCheck(vr);
        
        % see if there will be another stress trial
        if vr.timeElapsed - vr.sessionData.trialTime(end) >= vr.session.trialDuration*vr.sessionData.trialNum
            vr.state.onTrial = false;
            % remember which world an dposition we were
            vr.lastWorld = vr.currentWorld;
            vr.lastWorldPos = vr.position(2);
            display(vr.lastWorldPos);
            vr = startStress(vr);
            fprintf('Stress period starts.\n'); 
        end
    
        % terminate the trial if necessary
        if vr.timeElapsed - vr.sessionData.startTime >= vr.session.numTrials*(vr.session.trialDuration + vr.session.stressDuration)
            % vr.startTime = vr.timeElapsed;
            vr.state.onTrial = false;
            vr = stimOff(vr);
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
    if vr.state.onHabituation & vr.timeElapsed - vr.sessionData.startTime >= vr.session.trialDuration
        vr.state.onHabituation = false;
        vr.sessionData.endTime = vr.timeElapsed;
        vr = startPadding(vr);
    end
    % habituation block ends


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    % log the time in case the user escaped
    if ~vr.endTime & vr.sessionData.startTime & ~strcmp(vr.session.experiment, 'habituation')
        vr.sessionData.endTime = vr.timeElapsed;
        % turn the stim off in case the user escaped and log it
        vr = stimOff(vr);
    end
    vr.sessionData.stimoff = reshape(vr.sessionData.stimoff, 2, []);
    vr.sessionData.stimon = reshape(vr.sessionData.stimon, 2, []);
    vr.sessionData.ition = reshape(vr.sessionData.ition, 2, []);
    vr.sessionData.reward = reshape(vr.sessionData.reward, 2, []);
    vr.sessionData.licks = reshape(vr.sessionData.licks, 2, []);
    
    sessionData = vr.sessionData;
    session = vr.session;
    save(sprintf('%s/data/%s_%s_%i_%s.mat',...
        vr.session.basedir, vr.session.mouse, vr.session.date, vr.session.run, vr.session.experiment),...
        'session', 'sessionData');
    
    if vr.session.serial
        % turn the stim off just to be safe
        arduinoWriteMsg(vr.arduino_serial, 'O'); % terminate stim in case it was left on for whatever reason
        arduinoWriteMsg(vr.arduino_serial, 'C'); % disbale cam pulsing
        terminationForSerial(vr);
    end