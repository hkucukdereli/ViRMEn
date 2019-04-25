function code = TrialStim
% TrialStim   Code for the ViRMEn experiment tennisCourt.
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
                        'run', 1,...
                        'rig', 'VR_training',...
                        'experiment', 'testing',...
                        'basedir', 'C:/Users/hkucukde/Dropbox/Hakan/AndermannLab/code/MATLAB/ViRMEn',...
                        'timeout', 60,...
                        'blackOutDuration', 2,...
                        'cueList', struct('stim', 'CueStripe45',...
                                          'neutral','CueStripe135'),...
                        'serial', true,...
                        'com', 5,...
                        'inTrial', false,...
                        'timeOut', true,...
                        'onStim', false,...
                        'training', vr.training,...
                        'imaging', vr.imaging);
                    
    vr.sessionData = struct('startTime', now(),...
                            'position',[],...
                            'velocity', [],...
                            'timestamp', [],...
                            'stimon', [],...
                            'stimoff', [],...
                            'nTrials', 0);
                        
    vr.trialInfo(1:1000) = struct('trialNum', 0,...
                                              'trialType', 0,...
                                              'trialDuration',0,...
                                              'stimOn', 0);

    if vr.session.serial
        serialFix;
        vr = initializationForSerial(vr, vr.session.com);
    end
                              
    vr.nTrials = 0;
    vr.lastPos = 0;
    
    vr.initPos = vr.worlds{vr.currentWorld}.startLocation;
    
    vr.currentCue = vr.exper.userdata.cues(1,1);
    vr.previousCue = vr.exper.userdata.cues(1,1);
    
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
    
    vr.waitOn = true;
    vr.previousTime = vr.timeElapsed;
    
    fprintf('Press spacebar to start the experiment.\n');
    
% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
vr.position(2)
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
        
        if vr.currentCue == vr.session.cueList.('stim')
            vr.onStim = true;
            if vr.session.serial
                vr.sessionData.stimon = [vr.sessionData.stimon, vr.timeElapsed];
                arduinoWriteMsg(vr.arduino_serial, 'S');
            end
        elseif vr.currentCue == vr.session.cueList.('neutral')
            vr.onStim = false;
            if vr.session.serial
                vr.sessionData.stimoff = [vr.sessionData.stimoff, vr.timeElapsed];
                arduinoWriteMsg(vr.arduino_serial, 'O');
            end
        end
    elseif vr.waitOn & ~(vr.keyPressed == 32)
        vr.position(2) = vr.worlds{vr.currentWorld}.startLocation(2);
    end

    % update the position and cue lists
    vr.positions = vr.exper.userdata.positions(vr.currentWorld,:);
    vr.cuelist = vr.exper.userdata.cues(vr.currentWorld,:);
    
    % find out the position falls into which cue
    for p=1:length(vr.positions)-1
        if vr.position(2) > vr.positions(p) & vr.position(2) < vr.positions(p+1)
            vr.currentCue = vr.cuelist(p); 
        end
    end

    if vr.position(2) > vr.positions(end-vr.exper.userdata.overlaps )
        vr.dp(:) = 0;
        vr.lastPos = vr.lastPos + vr.position(2);
        vr.currentWorld = round(vr.currentWorld) + 1;
%         vr.position(2) = vr.initPos(2);
        vr.position(2) = 0;
    end

    % only do something if the cue has changed
    if ~strcmp(vr.previousCue, vr.currentCue)
        if vr.currentCue == vr.session.cueList.('stim')
            vr.onStim = true;
            if vr.session.serial
                vr.sessionData.stimon = [vr.sessionData.stimon, vr.timeElapsed];
                arduinoWriteMsg(vr.arduino_serial, 'S');
            end
        elseif vr.currentCue == vr.session.cueList.('neutral')
            vr.onStim = false;
            if vr.session.serial
                vr.sessionData.stimoff = [vr.sessionData.stimoff, vr.timeElapsed];
                arduinoWriteMsg(vr.arduino_serial, 'O');
            end
        end
        % update the previous cue because the cue has changed
        vr.previousCue = vr.currentCue;
    end
    
    vr.sessionData.position = [vr.sessionData.position, vr.position(2) + vr.lastPos];
    vr.sessionData.velocity = [vr.sessionData.velocity, vr.velocity(2)];
    vr.sessionData.timestamp = [vr.sessionData.timestamp, vr.timeElapsed];


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
%     vr.sessionData.trialDuration = vr.trialDuration;

%     assignin('base', 'sessionData', vr.sessionData);
%     assignin('base', 'trialInfo', vr.trialInfo);
%     assignin('base', 'vr', vr);

    sessionData = vr.sessionData;
    trialInfo = vr.trialInfo;
    session = vr.session;
    save(sprintf('%s/data/%s_%s_%i_%s.mat', vr.session.basedir, vr.session.mouse, vr.session.date, vr.session.run, vr.session.experiment),...
        'session', 'sessionData', 'trialInfo');
    if vr.session.serial
        terminationForSerial(vr);
    end
