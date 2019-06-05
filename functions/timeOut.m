function vr = timeOut(vr)
    if vr.session.serial
        vr.sessionData.timeout = [vr.sessionData.timeout, [vr.timeElapsed, vr.position(2) + vr.lastPos]];
        vr.sessionData.cueid = [vr.sessionData.cueid, vr.cueid];
        vr.sessionData.cuetype = [vr.sessionData.cuetype, vr.currentCue];
        arduinoWriteMsg(vr.arduino_serial, 'T');
    end