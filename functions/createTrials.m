function exper = createTrials(experName, templateName, varargin)
% creates a new virmen experiment with multiple worlds

    p = inputParser;
    addOptional(p, 'movement', @moveForward);
    addOptional(p, 'transformation', @transformPerspectiveMex);
    addOptional(p, 'experiment', @TrialStim);
    addOptional(p, 'cueList', {['CueStripe45'], ['CueStripe135']});
    addOptional(p, 'save', true);
    parse(p, varargin{:});
    p = p.Results;

    % First load the templates
    temp = load(templateName, '-mat');
    
    % create an empty experiment
    exper = virmenExperiment;
    % remove the empty world
    exper.worlds = [];
    
    % populate the experiment
    exper.name = experName;
    exper.userdata.cuelist = p.cueList;
    exper.variables = temp.exper.variables;
    exper.variables.cueList = p.cueList;
    % set antialiasing to 6 at minimum
    if temp.exper.windows{1}.antialiasing < 6
        exper.windows{1}.antialiasing = 6;
    else
        exper.windows{1}.antialiasing = temp.exper.windows{1}.antialiasing;
    end
    % assign the default functions
    if ~length(p.movement)
        exper.movementFunction = temp.exper.movementFunction;
        exper.transformationFunction = temp.exper.transformationFunction;
        exper.experimentCode = temp.exper.experimentCode;
    else
        exper.movementFunction = p.movement;
        exper.transformationFunction = p.transformation;
        exper.experimentCode = p.experiment;
    end
    
    % update the code
    updateCodeText(exper);
    
    % fetch the objects from the template to use later
    worlds = temp.exper.worlds;
    arenaFloor = [];
    cueWalls = struct(p.cueList{1},[]);
    % create a new template world
    tempWorld = virmenWorld;
    for i=1:length(worlds)
        if strcmp(worlds{i}.name, 'ArenaFloor')
            % get some variables from the template to use later
            wallHeight = str2num(exper.variables.wallHeight);
            arenaL = str2num(exper.variables.arenaL);
            arenaW = str2num(exper.variables.arenaW);
            startLocation = temp.exper.worlds{i}.startLocation;
            tempWorld.startLocation = startLocation;
            tempWorld.backgroundColor = temp.exper.worlds{i}.backgroundColor;
            tempWorld.variables = exper.variables;
            for k=1:length(worlds{i}.objects)
                if strcmp(worlds{i}.objects{k}.name, 'ArenaFloor')
                    % get the arena floor object
                    arenaFloor = temp.exper.worlds{i}.objects{k}.copyItem;
                end
            end
        else
            % get the cue wall objects
            for j=1:length(p.cueList)
                if strcmp(worlds{i}.name, p.cueList{j})
                    cueWalls.(p.cueList{j}) = temp.exper.worlds{i}.objects{1}.copyItem;
                elseif strcmp(worlds{i}.name, p.cueList{j})
                    cueWalls.(p.cueList{j}) = temp.exper.worlds{i}.objects{1}.copyItem;
                end
            end
        end
    end
    
    % add new worlds and each will have a different cue
	for w=1:length(p.cueList);
        % add a new world
        tempWorld.name = p.cueList{w};
        addWorld(exper, tempWorld);
        exper.worlds{w}.name = sprintf('%s', p.cueList{w});
        % add the arena floor ro the new world
        addObject(exper.worlds{w}, arenaFloor);
        % add the right cue wll to the new world
        addObject(exper.worlds{w}, cueWalls.(p.cueList{w}));
    end
   
    % save the experiment if needed
    if p.save
        save(sprintf('./experiments/%s', experName), 'exper');
    else
        warning('New experiment is created but not saved.');
    end
    