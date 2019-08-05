function vr = startTrial(vr)
    vr.state.onTrial = true;
    % enable cam pulses
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, 'PP');
    end
    % make the world visible and for trial
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
    % initialize the position
    position(2) = vr.initPos(2);