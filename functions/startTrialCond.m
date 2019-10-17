function vr = startTrialCond(vr)
    if ~vr.state.onTrial
        if rand > 0.5
            vr.state.onTrial = 2;
        else
            vr.state.onTrial = 3;
        end
    end
    
    fprintf('Trial starts: trial number %i\n', vr.sessionData.trialNum);
    
    % vr.sessionData.trialNum = vr.sessionData.trialNum + 1;
    vr.sessionData.trialTime = [vr.sessionData.trialTime, vr.timeElapsed];
  
    % enable cam pulses
    if vr.session.serial && ~vr.state.onCam
        arduinoWriteMsg(vr.arduino_serial, 'B');
        vr.state.onCam = true;
    end
    % make the world visible and for trial
    vr.currentWorld = findWorld(vr.exper.worlds, vr.session.cueList.gray);
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
    vr.currentCue = vr.session.cueList.gray;
    
    % initialize the position
    vr.position(2) = vr.exper.worlds{vr.currentWorld}.startLocation(2);
    vr.dp(:) = 0; % prevent any additional movement during teleportation
    % position(2) = vr.initPos(2);
