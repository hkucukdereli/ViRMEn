function vr = teleportCheckTransition(vr)
% check if teleportation is needed to keep the world continues
    
    initPos = vr.worlds{vr.currentWorld}.startLocation;
    arenaL = str2num(vr.exper.worlds{vr.currentWorld}.variables.arenaL);
    if vr.position(2) >= arenaL/4 % test if the animal is at the end of the track (y > threshold)
        vr.lastPos = vr.lastPos + vr.position(2);
        vr.position(2) = initPos(2); % set the animal’s y position to 0
        vr.dp(:) = 0; % prevent any additional movement during teleportation
    end
