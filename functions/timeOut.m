function vr = timeOut(vr)
    fprintf(' \b...Time out!');

    vr.sessionData.timeout = [vr.sessionData.timeout, [vr.timeElapsed; vr.position(2) + vr.lastPos]];
    % vr.sessionData.cueid = [vr.sessionData.cueid, vr.cueid];
    % vr.sessionData.cuetype = [vr.sessionData.cuetype, vr.currentCue];
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, 'T');
    end