function vr = startHabituation(vr)
    vr.state.onHabituation = true;
    % make the world visible and for trial
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 1;
    % initialize the position
    position(2) = vr.initPos(2);