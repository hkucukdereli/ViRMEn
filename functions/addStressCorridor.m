function exper = addStressCorridor(exper, tempWorld, arenaFloor, cueWalls, nWorlds)
    addWorld(exper, tempWorld);
    exper.worlds{nWorlds+1}.name = sprintf('Arena_%i', nWorlds+1);

    % add the arena floor ro the new world
    addObject(exper.worlds{nWorlds+1}, arenaFloor);
    exper.worlds{nWorlds+1}.objects{end}.height = 8000;
    exper.worlds{nWorlds+1}.objects{end}.y = 0;
    
    % add gray walls
    addObject(exper.worlds{nWorlds+1}, cueWalls.('CueGray'));
    exper.worlds{nWorlds+1}.objects{end}.width = 8000;
    exper.worlds{nWorlds+1}.objects{end}.y = 0;
    
    exper.worlds{nWorlds+1}.startLocation = exper.worlds{1}.startLocation;
    exper.worlds{nWorlds+1}.startLocation(2) = 0;
    
