function code = Conditioning
% Conditioning   Code for the ViRMEn experiment tennisCourt.
% code = Conditioning   Returns handles to the functions that ViRMEn
% executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT

% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
    vr.training = false;
    vr.behavior = true;
    vr.imaging = false;
    
    vr.session = struct('mouse', 'HK00',...
                        'date', '190405',...
                        'run', 2,...
                        'rig', 'VR_training',...
                        'experiment', 'conditioning',...
                        'basedir', 'C:/Users/hkucukde/Dropbox/Hakan/AndermannLab/code/MATLAB/ViRMEn',...
                        'trials', 2,...
                        'trialDuration', 10,...
                        'blackOutDuration', 5,...
                        'cueList', struct('stim', 'CueStripe45',...
                                          'neutral','CueStripe135'),...
                        'serial', true,...
                        'com', 5,...
                        'blackOut', false,...
                        'inTrial', false,...
                        'onShock', true,...
                        'training', vr.training,...
                        'imaging', vr.imaging);
                    
    vr.sessionData = struct('startTime', now(),...
                            'position',[],...
                            'velocity', [],...
                            'nTrials', 0);
                        
    vr.trialInfo(1:vr.session.trials) = struct('trialNum', 0,...
                                              'trialType', 0,...
                                              'trialDuration',0,...
                                              'stimOn', 0);

    if vr.session.serial
        serialFix;
        vr = initializationForSerial(vr, vr.session.com);
    end
                              
    vr.trialDuration = [vr.session.trialDuration];
    vr.nTrials = 0;
    vr.lastPos = 0;
    
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
    
    vr.waitOn = true;
    vr.previousTime = vr.timeElapsed;
    
    fprintf('Press spacebar to start the experiment.\n');
    
% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

    % Press space to start
    if vr.waitOn & vr.keyPressed == 32
        vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
        vr.session.inTrial = true;
        vr.session.blackOut = false;
        vr.waitOn = false;
        vr.previousTime = vr.timeElapsed;
        
        % initialize the trial count
        vr.sessionData.nTrials = 1;
        vr.trialInfo(vr.sessionData.nTrials).trialNum = vr.sessionData.nTrials;
        vr.trialInfo(vr.sessionData.nTrials).trialDuration = vr.session.trialDuration;
        
        % check the first cue to see if stim needs to be on
        % turn on/off the stim
        if vr.session.serial
            if ~vr.session.blackOut & vr.session.inTrial & any(strcmp(fieldnames(vr.worlds{vr.currentWorld}.objects.indices), vr.session.cueList.('stim')))
                arduinoWriteMsg(vr.arduino_serial, 'S');
                vr.trialInfo(vr.sessionData.nTrials).stimOn = 1;
                vr.trialInfo(vr.sessionData.nTrials).trialType = 'stim';
            elseif any(strcmp(fieldnames(vr.worlds{vr.currentWorld}.objects.indices), vr.session.t.('neutral')))
                arduinoWriteMsg(vr.arduino_serial, 'O');
                vr.trialInfo(vr.sessionData.nTrials).stimOn = 0;
                vr.trialInfo(vr.sessionData.nTrials).trialType = 'neutral';
            end
        end
    elseif vr.waitOn & ~(vr.keyPressed == 32)
        vr.position(2) = vr.worlds{vr.currentWorld}.startLocation(2);
    end

    if vr.session.blackOut == false & vr.session.inTrial == true & (vr.timeElapsed - vr.previousTime) > vr.trialDuration
        % change the world to the next one and teleport to the start
        vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
        % change states
        vr.session.blackOut = true;
        vr.session.inTrial = false;
        
        % turn off the stim during blackout
        if vr.session.serial
            if vr.session.blackOut | any(strcmp(fieldnames(vr.worlds{vr.currentWorld}.objects.indices), vr.session.cueList.('neutral')))
                arduinoWriteMsg(vr.arduino_serial, 'O');
            end
        end
        
        % timestamp
        vr.previousTime = vr.timeElapsed;
    end
    
    if vr.session.blackOut == true & vr.session.inTrial ==false & (vr.timeElapsed - vr.previousTime) > vr.session.blackOutDuration
        % start a new trial %
        % make the world visible
        vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
        % change states
        vr.session.blackOut = false;
        vr.session.inTrial = true;
        % timestamp
        vr.previousTime = vr.timeElapsed;
        
        % change the world to the next one and teleport to the start
        vr.currentWorld = mod(vr.currentWorld, length(vr.exper.worlds)) + 1;
        initPos = vr.worlds{vr.currentWorld}.startLocation;
        vr.position(2) = initPos(2); % set the animal’s y position to 0
        vr.dp(:) = 0; % prevent any additional movement during teleportation
        
        % advance the trial number
        vr.sessionData.nTrials = vr.sessionData.nTrials + 1;
        vr.trialInfo(vr.sessionData.nTrials).trialNum = vr.sessionData.nTrials;
        % set the next trial duration
        vr.trialDuration = [vr.trialDuration, vr.trialDuration];
        vr.trialInfo(vr.sessionData.nTrials).trialDuration = vr.trialDuration(vr.sessionData.nTrials);
        
        % turn on/off the stim
        if vr.session.serial
            if ~vr.session.blackOut & any(strcmp(fieldnames(vr.worlds{vr.currentWorld}.objects.indices), vr.session.cueList.('stim')))
                arduinoWriteMsg(vr.arduino_serial, 'S');
                vr.trialInfo(vr.sessionData.nTrials).stimOn = 1;
                vr.trialInfo(vr.sessionData.nTrials).trialType = 'stim';
            elseif any(strcmp(fieldnames(vr.worlds{vr.currentWorld}.objects.indices), vr.session.cueList.('neutral')))
                arduinoWriteMsg(vr.arduino_serial, 'O');
                vr.trialInfo(vr.sessionData.nTrials).stimOn = 0;
                vr.trialInfo(vr.sessionData.nTrials).trialType = 'neutral';
            end
        end
        
        % reset the last position
        vr.lastPos = 0;
    end

    vr = teleportCheck(vr);
    
    vr.sessionData.position = [vr.sessionData.position, vr.position(2) + vr.lastPos];
    vr.sessionData.velocity = [vr.sessionData.velocity, vr.velocity(2)];

    if vr.sessionData.nTrials > vr.session.trials
        vr = terminationCodeFun(vr);
    end

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    % turn off the stim before termination 
    arduinoWriteMsg(vr.arduino_serial, 'O');
    
    vr.sessionData.trialDuration = vr.trialDuration;
    
%     assignin('base', 'sessionData', vr.sessionData);
%     assignin('base', 'trialInfo', vr.trialInfo);
%     assignin('base', 'vr', vr);

    sessionData = vr.sessionData;
    trialInfo = vr.trialInfo;
    save(sprintf('%s/data/%s_%s_%i_%s.mat', vr.session.basedir, vr.session.mouse, vr.session.date, vr.session.run, vr.session.experiment),...
        'sessionData', 'trialInfo');
    if vr.session.serial
        terminationForSerial(vr);
    end
