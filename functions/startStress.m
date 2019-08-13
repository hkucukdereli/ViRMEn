function vr = startStress(vr)
    vr.state.onStress = true;
    % enable cam pulses
    if vr.session.serial & ~vr.state.onCam
        arduinoWriteMsg(vr.arduino_serial, 'B');
        vr.state.onCam = true;
    end
    % make the world visible and for trial
    vr.currentWorld = vr.exper.userdata.nWorlds+1;
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
    % initialize the position
    position(2) = vr.initPos(2);