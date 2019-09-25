function vr = ITIon(vr)
    fprintf(' \nEntering iti zone.');
    vr.plot(1).color = [1 0 0];
    
    vr.sessionData.ition = [vr.sessionData.ition, [vr.timeElapsed; vr.position(2) + vr.lastPos]];
    vr.sessionData.cueid = [vr.sessionData.cueid, vr.cueid];
    vr.sessionData.cuetype = [vr.sessionData.cuetype, vr.currentCue];
        
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, 'O');
    end