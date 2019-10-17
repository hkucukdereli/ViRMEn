function out = findWorld(worlds, cuetype)
    for w=1:length(worlds)
        if strcmp(worlds{w}.name, cuetype)
            out = w;
        end
    end