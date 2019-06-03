function vr = logData(vr)
    vr.sessionData.position = [vr.sessionData.position, vr.position(2) + vr.lastPos];
    vr.sessionData.velocity = [vr.sessionData.velocity, vr.velocity(2)];
    vr.sessionData.timestamp = [vr.sessionData.timestamp, vr.timeElapsed];