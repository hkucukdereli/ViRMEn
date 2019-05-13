function exper = createTrials(experName, templateName, varargin)
% creates a new virmen experiment with multiple worlds

    p = inputParser;
    addOptional(p, 'movement', @moveForward);
    addOptional(p, 'transformation', @transformPerspectiveMex);
    addOptional(p, 'experiment', @TrialStim);
    addOptional(p, 'cueList', {['CueStripe45'], ['CueStripe135']});
    addOptional(p, 'nWorlds', 10);
    addOptional(p, 'overlap', 4);
    addOptional(p, 'arenaL', 5000);
    addOptional(p, 'cueL', 500);
    addOptional(p, 'save', true);
    addOptional(p, 'shuffle', 20);
    parse(p, varargin{:});
    p = p.Results;
    
    window = round(p.arenaL / p.cueL);
    if p.shuffle < window
        p.shuffle = window;
    end

    if p.shuffle
        lenArr = [];
        lens = p.cueL + round(exprnd(250, 1, 2*window));
        for k=1:p.nWorlds
            lenArr = [lenArr, lens(randperm(length(lens)))];
        end
    else
        lenArr = round(normrnd(p.cueL, p.cueL*0.2, 1, window * p.nWorlds));
    end
    figure;hold on;histogram(lenArr);

%     lenArr = repmat(lenArr, [1, p.nWorlds]);
    n_start = 1;
    n_end = window;
    posArr = [];
    for i=1:p.nWorlds
        posArr = [posArr; [0, cumsum(lenArr(n_start : n_end))]];
        n_start = n_start + window - p.overlap;
        n_end = n_end + window - p.overlap;
    end
    
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
    
    cues = repmat(p.cueList, size(lenArr));
    cues = cues(1, 1:size(lenArr, 2));
    exper.userdata.cuestrack = cues;
    exper.userdata.cues = strings(size(posArr(:,2:end)));
    n_start = 1;
    n_end = window;
    for i=1:p.nWorlds
        exper.userdata.cues(i,:) = cues(n_start : n_end);
        n_start = n_start + window - p.overlap;
        n_end = n_end + window - p.overlap;
    end
    
    exper.userdata.nWorlds = p.nWorlds;
    exper.userdata.overlaps = p.overlap;
    exper.userdata.positions = posArr;
    exper.userdata.postrack = lenArr;
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
            wallHeight = str2num(exper.variables.wallHeight);
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
    
%     exper.userdata.cues = posArr(:,2:end);
%     exper.userdata.cues = strings(size(posArr, 1), size(posArr, 2)-1);
    % add new worlds and each will have a different cue
	for w=1:p.nWorlds;
        % add a new world
%         tempWorld.name = p.cueList{w};
        addWorld(exper, tempWorld);
        exper.worlds{end}.name = sprintf('Arena_%i', w);
        exper.worlds{end}.userdata = exper.userdata;
%         exper.worlds{w}.name = sprintf('%s', p.cueList{w});
        % add the arena floor ro the new world
        addObject(exper.worlds{w}, arenaFloor);
        exper.worlds{w}.objects{end}.height = posArr(w,end);
        exper.worlds{w}.objects{end}.y = repmat(posArr(w,end)/2, [2,1]);
        % add the right cue walls to the new world
        for o=1:size(posArr, 2)-1
%             cueInd = 2 - mod(o, 2);
%             addObject(exper.worlds{w}, cueWalls.(p.cueList{cueInd}));
            
            currentCue = exper.userdata.cues(w, o);
            addObject(exper.worlds{w}, cueWalls.(char(currentCue)));
            
            dis = posArr(w, o+1) - posArr(w, o);
            exper.worlds{w}.objects{end}.width = dis;
            exper.worlds{w}.objects{end}.y = repmat(posArr(w, o) + dis*0.5, [2,1]);
            exper.worlds{w}.objects{end}.tiling = [1, dis / wallHeight];
        end
    end
    
    % update the code
    updateCodeText(exper);
    
    % save the experiment if needed
    if p.save
        save(sprintf('./experiments/%s', experName), 'exper');
    else
        warning('New experiment is created but not saved.');
    end
    