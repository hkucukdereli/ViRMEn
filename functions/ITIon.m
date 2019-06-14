function vr = ITIon(vr)
    if vr.session.serial
        vr.sessionData.ition = [vr.sessionData.ition, [vr.timeElapsed, vr.position(2) + vr.lastPos]];
        vr.sessionData.cueid = [vr.sessionData.cueid, vr.cueid];
        vr.sessionData.cuetype = [vr.sessionData.cuetype, vr.currentCue];
        arduinoWriteMsg(vr.arduino_serial, 'O');
    end