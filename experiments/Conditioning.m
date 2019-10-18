function code = Conditioning
% Conditioning   Code for the ViRMEn experiment Conditioning.
%   code = Conditioning   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT



% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
    vr.session = struct('mouse', 'TP00',...
                        'date', '191018',...
                        'run', 1,...
                        'cueList', struct('stim', 'CueStripe90',... % stim or neutral
                                          'neutral','CueCheckers',... % stim
                                          'gray', 'CueGray'),...
                        'notes', '',...
                        'config','debug_cfg');
                    
    vr.state = struct('onWait',true, 'onKey',false, 'onCam',false, 'onCue',false,...
                      'onStress',false, 'onPadding',false, 'onTrial',false,...
                      'onStim',false, 'onITI',false, 'onNeutral',false, 'onHabituation',false,...
                      'onBlackOut',false, 'onPlot',false, 'onDAQ',false);

    vr.sessionData = struct('startTime', 0, 'endTime', 0, 'trialNum', 0, 'cueNum',0,...
                        'trialTime', [], 'stressTime', [],...
                        'position',[], 'velocity', [], 'timestamp', [],...
                        'stimon', [], 'stimoff', [], 'ition', [],...
                        'timeout',[], 'cuetype',[], 'cueid', [],...
                        'shockTime', [], 'shockCount', []);
    
    vr.session.cuetime = 20;
    vr.session.transitiontime = 60;
    
    if rand >= 0.5
        vr.cueOrder = {vr.session.cueList.stim, vr.session.cueList.neutral};
    else
        vr.cueOrder = {vr.session.cueList.neutral, vr.session.cueList.stim};
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
    
    % set the shock times
    vr.shockCount = 1;
    vr = initializeShocks(vr);
    
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
    vr.lastWorld = findWorld(vr.exper.worlds, vr.session.cueList.gray);
    % vr.lastWorld = vr.currentWorld;
    
    % set the current world to the shock context
    vr.currentWorld = findWorld(vr.exper.worlds, vr.session.cueList.gray);

    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
    vr.waitOn = true;
    
    fprintf(['Press S to test the shock during the waiting period.\n',...
             'Press spacebar to start the experiment.\n']);



% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    % log the data
    vr = logData(vr);
    
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
        vr = startStressCond(vr);
        vr.lastPos = vr.lastPos + vr.position(2);
        vr.sessionData.trialNum = vr.sessionData.trialNum + 1; % add to the trial number
        vr.startTime = vr.timeElapsed;
        vr.sessionData.startTime = vr.timeElapsed;
    end
    % wait block ends
    
    % stress starts
    if vr.state.onStress
        vr.lastPos = vr.lastPos + vr.position(2);
        vr = teleportCheck(vr); % keep the mouse in the iti zone as long as the stress is on
        % deliver shocks when necessary
        if vr.shockCount < length(vr.sessionData.stressShocks{vr.sessionData.trialNum}) && vr.timeElapsed - vr.sessionData.stressTime(end) > vr.sessionData.stressShocks{vr.sessionData.trialNum}(vr.shockCount)
            vr = badMouse(vr);
        end
        if vr.timeElapsed - vr.sessionData.stressTime(end) >= vr.session.stressDuration
            % end stress and move to trial block
            vr.state.onStress = false;
            vr.state.onTrial = 1;
            vr.shockCount = 1; % reset the shock count
            
            % Start the trial with a gray cue
            fprintf(' \nEntering iti zone.');
            vr.state.onITI = 1;
            vr.lastTime = vr.timeElapsed;
            % make the world visible and for trial
            vr.currentWorld = findWorld(vr.exper.worlds, vr.session.cueList.gray);
            vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
            % initialize the position
            vr.position(2) = vr.initPos(2);
            vr.dp(:) = 0; % prevent any additional movement during teleportation
            % iti on
            vr.sessionData.ition = [vr.sessionData.ition, [vr.timeElapsed; vr.position(2) + vr.lastPos]];
            vr.sessionData.cuetype = [vr.sessionData.cuetype, {vr.session.cueList.gray}];
            if vr.session.serial, arduinoWriteMsg(vr.arduino_serial, 'O'); end
        end
    end
    % stress ends
    
    % trial starts
    if vr.state.onTrial
        % 1. iti %
        %%%%%%%%%%
        if vr.state.onITI == 1
            vr.lastPos = vr.lastPos + vr.position(2);
            vr = teleportCheck(vr);

            if vr.timeElapsed - vr.lastTime >= vr.session.cuetime
                vr.state.onITI = 2;
                vr.lastTime = vr.timeElapsed;
                
                % new iti sets the next cue as well as transitions
                vr.sessionData.cueNum = vr.sessionData.cueNum + 1; % add to the cue count
                vr.currentWorld = findWorld(vr.exper.worlds, vr.cueOrder{1+mod(vr.sessionData.cueNum,2)}) - 1;
                vr.position(2) = vr.worlds{vr.currentWorld}.startLocation(2); % set the animal’s initial y positino
                vr.dp(:) = 0; % prevent any additional movement during teleportation
            end
        end
        %%%

        % 2. iti to cue %
        %%%%%%%%%%%%%%%%%
        if vr.state.onITI == 2
            vr.lastPos = vr.lastPos + vr.position(2);

            if vr.timeElapsed - vr.lastTime >= vr.session.transitiontime || vr.position(2) >= str2num(vr.exper.variables.arenaL) / 4
                vr.state.onITI = 0;
                vr.state.onCue = 1;
                vr.lastTime = vr.timeElapsed;
                
                % entering the cue
                vr.currentWorld = findWorld(vr.exper.worlds, vr.cueOrder{1+mod(vr.sessionData.cueNum,2)});
                vr.position(2) = vr.worlds{vr.currentWorld}.startLocation(2); % set the animal’s initial y positino
                vr.dp(:) = 0; % prevent any additional movement during teleportation
                vr = stimOnOff(vr);
            end
        end
        %%%

        % 3. cue %
        %%%%%%%%%%
        if vr.state.onCue == 1
            vr.lastPos = vr.lastPos + vr.position(2);
            vr = teleportCheck(vr);

            if vr.timeElapsed - vr.lastTime >= vr.session.cuetime
                vr.state.onCue = 2;
                vr.lastTime = vr.timeElapsed;
                
                vr.currentWorld = findWorld(vr.exper.worlds, vr.cueOrder{1+mod(vr.sessionData.cueNum,2)}) + 1;
                vr.position(2) = vr.worlds{vr.currentWorld}.startLocation(2); % set the animal’s initial y positino
                vr.dp(:) = 0; % prevent any additional movement during teleportation
            end
        end
        %%%

        % 4. cue to iti %
        %%%%%%%%%%%%%%%%%
        if vr.state.onCue == 2
            vr.lastPos = vr.lastPos + vr.position(2);

            if vr.timeElapsed - vr.lastTime >= vr.session.transitiontime || vr.position(2) >= str2num(vr.exper.variables.arenaL) / 4
                vr.state.onCue = 0;
                vr.state.onITI = 1;
                vr.lastTime = vr.timeElapsed;
                
                % entering the iti
                vr.currentWorld = findWorld(vr.exper.worlds, vr.session.cueList.gray);
                vr.position(2) = vr.worlds{vr.currentWorld}.startLocation(2); % set the animal’s initial y positino
                vr.dp(:) = 0; % prevent any additional movement during teleportation
                fprintf(" \nEntering the iti zone.");
            end
            
            % decide what to do upon reaching the next iti 
            if vr.sessionData.cueNum >= 4*vr.sessionData.trialNum && vr.state.onCue == 2 && ~vr.state.onITI
                % proceed to the next stress period
                vr.state.onCue = false;
                vr.state.onITI = false;
                vr.state.onTrial = false;
                vr.state.onStress = true;
                if vr.sessionData.trialNum >= vr.session.numTrials
                    % terminate the experiment
                    vr.state.onTrial = false;
                    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
                    if vr.session.serial
                        arduinoWriteMsg(vr.arduino_serial, 'O'); % terminate stim in case it was left on for whatever reason
                        arduinoWriteMsg(vr.arduino_serial, 'C'); % disbale cam pulsing
                    end
                    vr.endTime = vr.timeElapsed;
                    vr.sessionData.endTime = vr.timeElapsed;
                    vr.experimentEnded = true;
                else
                    vr = startStressCond(vr);
                    vr.sessionData.trialNum = vr.sessionData.trialNum + 1; % add to the trial number
                end
            end
            
        end
        %%%
    
    end
    % trial ends



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
    
    vr.sessionData.cueid = [1:length(vr.sessionData.cuetype)];
    
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


