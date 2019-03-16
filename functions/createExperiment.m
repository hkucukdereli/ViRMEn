function exper = createExperiment(experName, templateName, worldN, overlap)
% creates a new virmen experiment with multiple worlds
% inputs
% experName: name of the experiment file to save the experiment data
% templateName: name of the experiment file that contains the template data
% worldN: number of worlds to be created
% returns
% exper: new virmen experiment 

    % First load the templates
    temp = load(templateName, '-mat');
    worlds = temp.exper.worlds;
    
    % create an empty experiment
    exper = virmenExperiment;
    
    % set antialiasing to 6
    exper.windows{1, 1}.antialiasing = 6;
    % assign the default functions
    exper.movementFunction = temp.exper.movementFunction;
    exper.transformationFunction = temp.exper.transformationFunction;
    exper.experimentCode = temp.exper.experimentCode;
    
    % populate the new experiment
    exper = temp.exper.copyItem;
    % keep only one world with the arena floor
    exper.worlds= []; 
    for i=1:length(worlds)
        if strcmp(worlds{1,i}.name, 'ArenaFloor')
            % get a copy of the world with the floor plan
            exper.worlds{1,1} = temp.exper.worlds{1,i}.copyItem;
        end
    end
    
    % get some variables from the template to use later
    wallHeight = str2num(exper.variables.wallHeight);
    arenaL = str2num(exper.variables.arenaL);
    arenaW = str2num(exper.variables.arenaW);
    
    % create the position array
    posArr = round(normrnd(500, 80, 1, 1000),-1);
    c = round(arenaL / median(posArr), 0) + 1;
    posDist = cumsum(buffer(posArr, c, overlap), 1);
    posDist = posDist(:,2:worldN+1);
    posDist = [zeros(1, length(posDist)); posDist];
    
    % pick the cue order
    cueOrder = {['CuePlus'], ['CueCircle']};
    if round(rand())
        cueOrder = flip(cueOrder);
    end
    
    % get the floor and cue template from template file
    cue = struct(cueOrder{1},[], cueOrder{2},[]);
    for i=1:length(worlds)
        if strcmp(worlds{1,i}.name, cueOrder{1})
            % get a copy of the cue template
            cue.(cueOrder{1}) = worlds{1,i}.objects{1,1}.copyItem;
        end
        if strcmp(worlds{i}.name, cueOrder{2})
            % get a copy of the cue template
            cue.(cueOrder{2}) = worlds{1,i}.objects{1,1}.copyItem;
        end
    end
    
    % get on with the objects in the world
    posFloor = arenaL / 2;
    exper.worlds{1,1}.objects{1,1}.y = [posFloor; posFloor];
    
    objectCount = length(exper.worlds{1,1}.objects);
    s = size(posDist);
    % add new worlds
    for w=1:worldN
        % add more worlds after the first one
        if w > 1
            addWorld(exper, temp.exper.worlds{1,i}.copyItem);
        end
        % rename the world
        exper.worlds{1,w}.name = sprintf('Arena_%i', w);
        % keep some important data to use later
        exper.worlds{1,w}.userdata.posDist = posDist(:,w);
        exper.worlds{1,w}.userdata.cueOrder = cueOrder;
        exper.worlds{1,w}.userdata.overlap = overlap;
        
        % add cue objets to the new worlds
        for ob=1:s(1)-1
            cueInd = 2-mod(ob,2);
            addObject(exper.worlds{1,w}, cue.(cueOrder{cueInd}));
            % rename the new object
            exper.worlds{1,w}.objects{1,end}.name = sprintf('%s_%i', cueOrder{cueInd}, objectCount);
            % position of the cue
            posY = posDist(ob, w) + ((posDist(ob+1, w) - posDist(ob, w)) / 2);
            exper.worlds{1,w}.objects{1,end}.y = [posY; posY];
            % length of the cue
            cueLength = posDist(ob+1, w) - posDist(ob, w);
            exper.worlds{1,w}.objects{1,end}.width = cueLength;
            % adjust the tiling
            rows = 2;
            cols = rows * cueLength / wallHeight;
            exper.worlds{1,w}.objects{1,end}.tiling = [rows, cols];
        end
    end
 
    exper.name = experName;
    save(sprintf('./experiments/%s', experName), 'exper');
    
end