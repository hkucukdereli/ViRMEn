function vr = stimOn(vr)
    fprintf(' \nEntering stim zone.');
    vr.plot(1).color = [0 0 1];

    vr.sessionData.stimon = [vr.sessionData.stimon, [vr.timeElapsed; vr.position(2) + vr.lastPos]];
    vr.sessionData.cueid = [vr.sessionData.cueid, vr.cueid];
    vr.sessionData.cuetype = [vr.sessionData.cuetype, vr.currentCue];
        
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, 'S');
    end