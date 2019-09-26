function vr = logData(vr)
    vr.sessionData.position = [vr.sessionData.position, vr.position(2) + vr.lastPos];
    vr.sessionData.velocity = [vr.sessionData.velocity, vr.velocity(2)];
    vr.sessionData.timestamp = [vr.sessionData.timestamp, vr.timeElapsed];
    
    if vr.state.onDAQ && strcmp(vr.daq.daqtype, 'counter')
        vr.daq.data.timestamp = [vr.daq.data.timestamp, vr.timeElapsed];
        for j=1:length(vr.daq.channelnames), vr.daq.data.vr.daq.channelnames{j} = vr.daq.session.inputSingleScan(j + 1);end
    end
