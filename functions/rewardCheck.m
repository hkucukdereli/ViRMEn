function vr = rewardCheck(vr)
    % see if there's reward to be given
    if vr.state.onReward & vr.timeElapsed - vr.stimTime >= vr.rewardDelay
        % deliver a pavlovian reward
        vr = goodMouse(vr, vr.session.rewardsize/600);
        vr.state.onReward = false;
    end
    % listen to licks during trial
    if vr.session.lick
        vr = listenLick(vr);
    end