function vr = moveStim(vr)
    y = vr.worlds{vr.currentWorld}.surface.vertices(2, vr.stimInd);
    % increase the y coordinates by 5 units
    vr.worlds{vr.currentWorld}.surface.vertices(2, vr.stimInd) = round(vr.position(2)) + 100;