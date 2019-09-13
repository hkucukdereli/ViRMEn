function vr = stimOff(vr)
    fprintf(' \bEntering neutral zone.\n');
    vr.plot(1).color = [0 0 0];
    
    vr.sessionData.stimoff = [vr.sessionData.stimoff, [vr.timeElapsed, vr.position(2) + vr.lastPos]];
    vr.sessionData.cueid = [vr.sessionData.cueid, vr.cueid];
    vr.sessionData.cuetype = [vr.sessionData.cuetype, vr.currentCue];
    
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, 'O');
    end