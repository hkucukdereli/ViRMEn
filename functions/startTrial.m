function vr = startTrial(vr)
    vr.state.onTrial = true;
    
    vr.sessionData.trialNum = vr.sessionData.trialNum + 1;
    vr.sessionData.trialTime = [vr.sessionData.trialTime, [vr.timeElapsed, vr.position(2) + vr.lastPos]];
  
    % enable cam pulses
    if vr.session.serial & ~vr.state.onCam
        arduinoWriteMsg(vr.arduino_serial, 'B');
        vr.state.onCam = true;
    end
    % make the world visible and for trial
    vr.currentWorld = vr.lastWorld;
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
    
    % initialize the position
    vr.position(2) = vr.lastWorldPos;
    vr.dp(:) = 0; % prevent any additional movement during teleportation
    % position(2) = vr.initPos(2);