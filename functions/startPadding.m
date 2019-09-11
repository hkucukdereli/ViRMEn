function vr = startPadding(vr)
    % log the start of the padding time
    vr.paddingTime = vr.timeElapsed;
    vr.state.onPadding = true;
    vr.paddingCount = vr.paddingCount + 1;
    % make the worlds invisible
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;