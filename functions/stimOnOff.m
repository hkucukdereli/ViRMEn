function vr = stimOnOff(vr)
    % stim on/off
    if strcmp(vr.cueOrder{1+mod(vr.sessionData.cueNum,2)}, vr.session.cueList.stim)
        vr.sessionData.stimon = [vr.sessionData.stimon, [vr.timeElapsed; vr.position(2) + vr.lastPos]];
        vr.sessionData.cuetype = [vr.sessionData.cuetype, {vr.session.cueList.stim}];
        if vr.session.serial, arduinoWriteMsg(vr.arduino_serial, 'S'); end
        fprintf(" \nEntering the stim cue. Cue count: %i", vr.sessionData.cueNum);
    end
    if strcmp(vr.cueOrder{1+mod(vr.sessionData.cueNum,2)}, vr.session.cueList.neutral)
        vr.sessionData.stimoff = [vr.sessionData.stimoff, [vr.timeElapsed; vr.position(2) + vr.lastPos]];
        vr.sessionData.cuetype = [vr.sessionData.cuetype, {vr.session.cueList.neutral}];
        if vr.session.serial, arduinoWriteMsg(vr.arduino_serial, 'O'); end
        fprintf(" \nEntering the neutral cue. Cue count: %i", vr.sessionData.cueNum);
    end