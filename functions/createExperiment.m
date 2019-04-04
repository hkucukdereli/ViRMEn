function exper = createExperiment(experName, templateName, varargin)
% creates a new virmen experiment with multiple worlds
% inputs
% experName: name of the experiment file to save the experiment data
% templateName: name of the experiment file that contains the template data
% worldN: number of worlds to be created
% returns
% exper: new virmen experiment 
    
    p = inputParser;
    addOptional(p, 'worldN', 4, @isnumeric);
    addOptional(p, 'overlap', 4, @isnumeric);
    addOptional(p, 'muLength', 500, @isnumeric);
    addOptional(p, 'sigLength', 80, @isnumeric);
    parse(p, varargin{:});
    p = p.Results;

    % only allow even numbers for overlap to keep the cue order consistent
    if mod(p.worldN, 2) | mod(p.overlap, 2)
        error('overlap and worldN has to be an even number.');
    end
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
    exper = temp.exper;
    % keep only one world with the arena floor
%     exper.worlds= []; 
    for i=1:length(worlds)
        if strcmp(worlds{1,i}.name, 'ArenaFloor')
            % get a copy of the world with the floor plan
            exper.worlds{1,1} = temp.exper.worlds{1,i}.copyItem;
            tempWorld = temp.exper.worlds{1,i}.copyItem;
        end
    end
    
    % get some variables from the template to use later
    wallHeight = str2num(exper.variables.wallHeight);
    arenaL = str2num(exper.variables.arenaL);
    arenaW = str2num(exper.variables.arenaW);
    startLocation = exper.worlds{1,1}.startLocation;

    arrLength = round(arenaL / p.muLength);
    posArr = round(normrnd(p.muLength, p.sigLength, 1, arrLength+p.worldN*(arrLength-p.overlap+1))/10)*10;
    posD = cumsum(posArr);
    posD = [0, posD];

    posDist(1,:) = posD(1:arrLength);
    c = 2;
    n = arrLength;
    for c=2:p.worldN
        posDist(c,:) = posD(n+1-p.overlap : n-p.overlap+arrLength);
        n = n-p.overlap+arrLength;
    end
    
    % pick the cue order
    cueOrder = {['CuePlus'], ['CueCircle']};
    if round(rand())
        cueOrder = fliplr(cueOrder);
    end
    
    % keep the position array
    exper.userdata.positions = posD(posD < posDist(end,end)+1);
    exper.userdata.cueOrder = cueOrder;
    
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
    
    % add new worlds
    for w=1:p.worldN
        % add more worlds after the first one
        if w > 1
            addWorld(exper, tempWorld);
%             addWorld(exper, temp.exper.worlds{1,1}.copyItem);
        end
        % rename the world
        exper.worlds{1,w}.name = sprintf('Arena_%i', w);
        % keep some important data to use later
        exper.worlds{1,w}.userdata.posDist = posDist(w,:);
        exper.worlds{1,w}.userdata.cueOrder = cueOrder;
        exper.worlds{1,w}.userdata.overlap = p.overlap;
        % adjust the world length
        arenaL = posDist(w,end) - posDist(w,1);
        exper.worlds{1,w}.variables.arenaL = num2str(arenaL);        
        % set the start location
        startLocation = startLocation + [0, posDist(w,1), 0, 0];
        exper.worlds{1,w}.startLocation = startLocation;
        
        % relocate the first object that is the floor
        posFloor = posDist(w,1) + (posDist(w,end) - posDist(w,1)) / 2;
        exper.worlds{1,w}.objects{1,1}.y = [posFloor; posFloor];
        exper.worlds{1,w}.objects{1,1}.variables.arenaL = num2str(arenaL);
        % add cue objets to the new worlds
        for ob=1:(size(posDist,2)-1)
            cueInd = 2-mod(ob,2);
            addObject(exper.worlds{1,w}, cue.(cueOrder{cueInd}));
            % rename the new object
            exper.worlds{1,w}.objects{1,end}.name = sprintf('%s_%i', cueOrder{cueInd}, ob+1);
            % position of the cue
            posY = posDist(w,ob) + (posDist(w,ob+1) - posDist(w,ob)) / 2;
            exper.worlds{1,w}.objects{1,end}.y = [posY; posY];
            % length of the cue
            cueLength = posDist(w,ob+1) - posDist(w,ob);
            exper.worlds{1,w}.objects{1,end}.width = cueLength;
            % adjust the tiling
            rows = 3;
            cols = rows * cueLength / wallHeight;
            exper.worlds{1,w}.objects{1,end}.tiling = [rows, cols];
        end
    end
 
    % add an end wall to the last world
    for j=1:length(worlds)
        if strcmp(worlds{1,j}.name, 'CueGray')
            for g=1:length(worlds{1,j}.objects)
                if strcmp(worlds{1,j}.objects{1,g}.name, 'EndWallForward')
                    addObject(exper.worlds{1,end}, worlds{1,j}.objects{1,g}.copyItem);
                    endPos = exper.worlds{1,end}.userdata.posDist(end);
                    exper.worlds{1,end}.objects{1,end}.y = [endPos; endPos];
                end
            end
        end
    end
     
    % save the experiment if needed
    if length(experName) > 0
        exper.name = experName;
        save(sprintf('./experiments/%s', experName), 'exper');
    else
        warning('New experiment is created but not saved.');
    end
    
end