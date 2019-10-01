function vr = startStress(vr)   
    vr.state.onStress = true;
    
    fprintf('Stress period starts.\n');
    
    vr.sessionData.stressTime = [vr.sessionData.stressTime, vr.timeElapsed];
    
    % enable cam pulses
    if vr.session.serial & ~vr.state.onCam
        arduinoWriteMsg(vr.arduino_serial, 'B');
        vr.state.onCam = true;
    end
    % make the world visible and for trial
    vr.currentWorld = vr.exper.userdata.nWorlds+1;
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
    % initialize the position
    vr.position(2) = vr.initPos(2);
    vr.dp(:) = 0; % prevent any additional movement during teleportation