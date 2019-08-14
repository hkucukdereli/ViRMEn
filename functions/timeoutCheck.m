function vr = timeoutCheck(vr)
    % see if time out is needed
    if vr.state.onStim & vr.state.onTimeout & vr.session.timeoutDuration & vr.timeElapsed - vr.stimTime >= vr.session.timeoutDuration
        vr.state.onTimeout = false;
        vr = timeOut(vr);
        vr.stimTime = 0;
    end