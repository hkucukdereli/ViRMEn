function vr = startPadding(vr)
    vr.state.onPadding = true;
    vr.paddingCount = vr.paddingCount + 1;
    % make the worlds invisible
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;