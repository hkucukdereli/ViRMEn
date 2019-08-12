function vr = startTrial(vr)
    vr.state.onTrial = true;
    % enable cam pulses
    arduinoWriteMsg(vr.arduino_serial, 'B');
    % make the world visible and for trial
    vr.currentWorld = 1;
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
    % initialize the position
    position(2) = vr.initPos(2);