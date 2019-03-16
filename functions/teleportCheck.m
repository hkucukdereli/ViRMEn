function vr = teleportCheck(vr, threshold)
    %  <vr.trialCount> needs to be initialized at the start up
    %%%
    initPos = vr.worlds{vr.currentWorld}.startLocation;
    initY = initPos(2);
    if vr.position(2) > threshold-1 % test if the animal is at the end of the track (y > threshold)
        vr.position(2) = initY; % set the animal’s y position to 0
        vr.dp(:) = 0; % prevent any additional movement during teleportation
        vr.trialCount =  vr.trialCount + 1;
    end
    