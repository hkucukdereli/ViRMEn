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
    vr.session = struct('mouse', 'RE29',...
                        'date', '190608',...
                        'run', 1,...
                        'experiment', 'trial',... %'habituation' or 'trial' or 'shock' or 'stress'
                        'cueList', struct('neutral', 'CueStripe45',... % options: stim, nostim or neutral
                                          'nostim','CueStripe135'),...
                        'notes', '',...
                        'config','vrrig_cfg');
    
    % load the variables from the config file
    run(vr.session.config);
    vr.session.expername = vr.exper.name;
    vr.session.rig = vrconfig.rig;
    vr.session.basedir = vrconfig.basedir;
    vr.session.serial = vrconfig.serial;
    vr.session.com = vrconfig.com;
    vr.session.trialDuration = vrconfig.trialDuration * 60; % sec
    vr.session.stressDuration = vrconfig.stressDuration * 60; % sec
    vr.session.blackoutDuration = vrconfig.blackoutDuration * 60; % sec
    vr.session.habituationDuration = vrconfig.habituationDuration * 60; % sec
    vr.session.timeoutDuration = vrconfig.timeoutDuration; % sec
    vr.session.conditioningDuration = vrconfig.conditioningDuration * 60; % sec
    vr.session.paddingDuration = vrconfig.paddingDuration * 60; % sec
    
    if strcmp(vr.session.experiment, 'trial') | strcmp(vr.session.experiment, 'stress') | strcmp(vr.session.experiment, 'shock')
        vr.session.cuelengths = vr.exper.userdata.postrack;
        vr.session.cuetypes = vr.exper.userdata.cuestrack;
        vr.currentCue = vr.exper.userdata.cues(1,1);
        vr.previousCue = vr.exper.userdata.cues(1,2);
    end
    
    if strcmp(vr.session.experiment, 'shock')
        if exist vr.exper.userdata.minepos
            vr.session.shockpos = vr.exper.userdata.minepos;
        else
            warning("Shock positions are not given.");
        end
    end

    vr.state = struct('onWait', true,...
                      'onStress', false,...
                      'onPadding', false,...
                      'onTrial', false,...
                      'onStim', false,...
                      'onHabituation', false,...
                      'onBlackOut', false);

    vr.sessionData = struct('startTime', 0,...
                            'endTime', 0,...
                            'stressTime', 0,...
                            'position',[],...
                            'velocity', [],...
                            'timestamp', [],...
                            'stimon', [],...
                            'stimoff', [],...
                            'timeout',[],...
                            'cuetype',[],...
                            'cueid', [],...
                            'shockTime', [],...
                            'shockCount', []);
                        
    % initialize the serial
    if vr.session.serial
        serialFix;
        vr = initializationForSerial(vr, vr.session.com);
    end
    
    % initialize shock count depending on the experiment
    if strcmp(vr.session.experiment, 'shock')
        vr.shockCount = 1;
    elseif strcmp(vr.session.experiment, 'stress')
        vr.shockCount = 1;
    elseif strcmp(vr.session.experiment, 'trial')
        vr.shockCount = 0;
    elseif strcmp(vr.session.experiment, 'habituation')
        vr.shockCount = 0;
    else
        warning("Wrong experiment type. Types to choose: trial, shock, stress.");
    end
    
    vr.startTime = 0;
    vr.endTime = 0;
    vr.stressTime = 0;
    vr.stimTime = 0;
    
    vr.paddingCount = 0;
    
    vr.initPos = vr.worlds{vr.currentWorld}.startLocation;
    vr.lastPos = 0;
    
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
    
    vr.waitOn = true;
    
    fprintf('Press spacebar to start the experiment.\n');
    
        
        
% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

    vr = logData(vr);
    
    % wait starts
    if vr.state.onWait
        vr.position(2) = vr.initPos(2);
%         if vr.state.onKey & vr.keyPressed
%         end
    end
    if vr.state.onWait & vr.keyPressed == 32
        % log the start time
        vr.startTime = vr.timeElapsed;
        
        % end wait and move to padding block
        vr.state.onWait = false;
        vr = startPadding(vr);
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
            elseif strcmp(vr.session.experiment, 'habituation')
                vr.sessionData.startTime = vr.startTime;
                vr = startHabituation(vr);
            elseif strcmp(vr.session.experiment, 'shock')
                vr.sessionData.startTime = vr.startTime;
                vr = startTrial(vr);
            elseif strcmp(vr.session.experiment, 'stress')
                vr.sessionData.stressTime = vr.startTime;
                vr.state.onStress = true;
            end
        elseif vr.paddingCount == 2
            vr.experimentEnded = true;
        end
    end
    % padding block ends
    
    % stress starts
    if vr.state.onStress
%         vr.position(2) = vr.initPos(2);
    end
    if vr.state.onStress & vr.timeElapsed - vr.startTime >= vr.session.stressDuration
        % log the start time
        vr.startTime = vr.timeElapsed;
        
        % end stress and move to trial block
        vr.state.onStress = false;
        vr.sessionData.startTime = vr.startTime;
        vr = startTrial(vr);
    end
    % stress block ends
    
    % trial start
    if vr.state.onTrial
        % see if time out is needed
        if vr.state.onStim & vr.state.onTimeout & vr.session.timeoutDuration & vr.timeElapsed - vr.stimTime >= vr.session.timeoutDuration
            vr.state.onTimeout = false;
            vr = timeOut(vr);
            vr.stimTime = 0;
        end

        % update the position and cue lists
        vr.positions = vr.exper.userdata.positions(vr.currentWorld,:);
        vr.cuelist = vr.exper.userdata.cues(vr.currentWorld,:);

        % find out the position falls into which cue
        for p=1:length(vr.positions)-1
            if vr.position(2) > vr.positions(p) & vr.position(2) < vr.positions(p+1)
                vr.currentCue = vr.cuelist(p); 
                vr.cueid = p + ((vr.currentWorld-1) * (length(vr.positions) - vr.exper.userdata.overlaps));
            end
        end
        
        % only do something if the cue has changed
        if ~strcmp(vr.previousCue, vr.currentCue)
            if any(strcmp(fieldnames(vr.session.cueList), 'stim'))
                if vr.currentCue == vr.session.cueList.('stim')
                    vr.state.onStim = true;
                    vr.state.onTimeout = true;
                    vr = stimOn(vr);
                    vr.stimTime = vr.timeElapsed;
                end
            elseif any(strcmp(fieldnames(vr.session.cueList), 'nostim'))
                if vr.currentCue == vr.session.cueList.('nostim')
                    vr.state.onStim = false;
                    vr = stimOff(vr);
                end
            end
            if any(strcmp(fieldnames(vr.session.cueList), 'neutral'))
                if vr.currentCue == vr.session.cueList.('neutral')
                    vr.state.onStim = false;
                    vr = stimOff(vr);
                end
            end

            % update the previous cue because the cue has changed
            vr.previousCue = vr.currentCue;
        end
        
        % see if the position is at the start of the overlap
        if vr.position(2) > vr.positions(end-vr.exper.userdata.overlaps)
            % stop all movement until we can figure out what to do
            vr.dp(:) = 0;
            % get the latest position to keep the position info continuous
            vr.lastPos = vr.lastPos + vr.position(2);
            % advance the world unless it's in the last one. 
            % otherwise, teminate the experiment gracefully
            if vr.currentWorld + 1 > vr.exper.userdata.nWorlds
                % make the worlds invisible
                vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
                % turn the stim off and log
                vr = stimOff(vr);
                
                % move to the padding block
                vr.state.onTrial = false;
                vr = stimOff(vr);
                vr.endTime = vr.timeElapsed;
                vr.sessionData.endTime = vr.timeElapsed;
                vr = startPadding(vr);
            else
                % advance the world and initialize the position
                vr.currentWorld = round(vr.currentWorld) + 1;
                vr.position(2) = 0;
            end
        end
    end
    
    if vr.state.onTrial & vr.timeElapsed - vr.startTime >= vr.session.trialDuration
        vr.startTime = vr.timeElapsed;
        vr.state.onTrial = false;
        vr = stimOff(vr);
        vr.endTime = vr.timeElapsed;
        vr.sessionData.endTime = vr.timeElapsed;
        vr = startPadding(vr);
    end
    % trial end
    
    % habituation starts
    if vr.state.onHabituation
        vr = teleportCheck(vr);
    end
    if vr.state.onHabituation & vr.timeElapsed - vr.startTime >= vr.session.trialDuration
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
        % turne the stim off in case the user escaped and log it
        vr = stimOff(vr);
    end
    vr.sessionData.stimoff = reshape(vr.sessionData.stimoff, 2, []);
    vr.sessionData.stimon = reshape(vr.sessionData.stimon, 2, []);
    
    sessionData = vr.sessionData;
    session = vr.session;
    save(sprintf('%s/data/%s_%s_%i_%s.mat',...
        vr.session.basedir, vr.session.mouse, vr.session.date, vr.session.run, vr.session.experiment),...
        'session', 'sessionData');
    
    if vr.session.serial
        % turn the stim off just to be safe
        arduinoWriteMsg(vr.arduino_serial, 'O');
        terminationForSerial(vr);
    end


