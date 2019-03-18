function vr = switchWorlds(vr)
    %  <vr.trialCount> needs to be initialized at the start up
    % menages switching between overlapping wolrds to keep the illusion of
    % a single track
    % only allows forward switching at the moment
    
    % get the initial position for the world
    initPos = vr.worlds{vr.currentWorld}.startLocation;
    % check which world is in use
    currentWorld = vr.currentWorld;
    userdata = vr.exper.worlds{1, currentWorld}.userdata;
    endPos = userdata.posDist(end-userdata.overlap+1);

    if vr.position(2) > endPos
        % switch the world to the next one
        vr.currentWorld = currentWorld + 1;
        % place the animal at the begining of the overlap
        vr.position(2) = initPos(2);
        vr.dp(:) = 0; % prevent any additional movement during fake teleportation
    end
    
end