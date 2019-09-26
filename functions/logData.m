function vr = logData(vr)
    vr.sessionData.position = [vr.sessionData.position, vr.position(2) + vr.lastPos];
    vr.sessionData.velocity = [vr.sessionData.velocity, vr.velocity(2)];
    vr.sessionData.timestamp = [vr.sessionData.timestamp, vr.timeElapsed];
    
    if vr.state.onDAQ && strcmp(vr.daq.daqtype, 'counter')
        vr.daq.data = [vr.daq.data, [vr.timeElapsed, vr.daq.session.inputSingleScan]'];
    end
