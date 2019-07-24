function vr = listenLick(vr)
    % Read data from Serial
    val = arduinoReadQuad(vr.arduino_serial_input);
    % display(val);
    if val > 0
        vr.licks = vr.licks + 1;
        vr.sessionData.licks = [vr.sessionData.licks, [vr.licks, vr.timeElapsed]];
    end