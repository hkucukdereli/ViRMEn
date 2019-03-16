function vr = switchWorlds(vr)
    %  <vr.trialCount> needs to be initialized at the start up
    %%%
    
    % get the initial position for the world
    initPos = vr.worlds{vr.currentWorld}.startLocation;
    % check which world is in use
    currentWorld = vr.currentWorld;
    userdata = vr.exper.worlds{1, currentWorld}.userdata;
    endPos = userdata.posDist(end-userdata.overlap+1);
    if vr.position(2) > endPos
        % switch the world to the next one
        vr.currentWorld = currentWorld + 1;
        vr.position(2) = initY;
        % place the animal at the begining of the overlap
        vr.dp(:) = 0; % prevent any additional movement during fake teleportation
    end
    
end