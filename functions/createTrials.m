function exper = createTrials(experName, templateName, varargin)
% creates a new virmen experiment with multiple worlds

    p = inputParser;
    addOptional(p, 'movement', @moveForward);
    addOptional(p, 'transformation', @transformPerspectiveMex);
    addOptional(p, 'experiment', @Trial_code);
    addOptional(p, 'cueList', {['CueStripe45'], ['CueStripe135']});
    addOptional(p, 'grayCue', {}); 
    addOptional(p, 'atrandom', false);
    addOptional(p, 'nWorlds', 10);
    addOptional(p, 'overlap', 4);
    addOptional(p, 'arenaL', 5000);
    addOptional(p, 'cueL', 500);
    addOptional(p, 'grayL', 1000);
    addOptional(p, 'save', true);
    addOptional(p, 'shuffle', 20);
    addOptional(p, 'shock', false);
    addOptional(p, 'tiling', 1);
    parse(p, varargin{:});
    p = p.Results;
    
    if p.atrandom
        if round(rand)
            cueList = flip(p.cueList);
        else
            cueList = p.cueList;
        end
    else
        cueList = p.cueList;
    end

    if length(p.grayCue)
        window = round(p.arenaL / (p.cueL + p.grayL));
        cueList = [p.grayCue, cueList(1), p.grayCue, cueList(2)];
    else
        window = round(p.arenaL / p.cueL);
        cueList = cueList;
    end
    
    if p.shuffle
        if length(p.grayCue)
            lenArr = [];
            for k=1:((p.arenaL * p.nWorlds) / (p.cueL + p.grayL)) * p.shuffle
                grays = p.grayL + round(exprnd(p.grayL*.2, 1, p.shuffle)); 
                lens = round(normrnd(p.cueL, p.cueL*.1, p.shuffle));
                temp = [grays(randperm(length(grays))); lens(randperm(length(lens))); grays(randperm(length(grays))); lens(randperm(length(lens)))];
                temp = temp(:)';
                lenArr = [lenArr, temp];
            end
        else
            lenArr = [];
            for k=1:((p.arenaL * p.nWorlds) / (p.cueL * p.shuffle))
                lens = p.cueL + round(exprnd(p.cueL*.2, 1, p.shuffle));
                temp = [lens(randperm(length(lens))); lens(randperm(length(lens)))];
                temp = temp(:)';
                lenArr = [lenArr, temp];
            end
        end
    else
        lenArr = round(normrnd(p.cueL, p.cueL*0.2, 1, window * p.nWorlds));
    end
    figure;hold on;histogram(lenArr);
    
    % adjust for the padding
    lenArrNew = lenArr;
    for i=2:2:(length(lenArrNew)-1)
        e1 = round(normrnd(p.cueL*.1,p.cueL*.01,1));
        e2 = round(normrnd(p.cueL*.3,p.cueL*.02,1));
        % e1 = round(f1 * lenArrNew(i));
        % e2 = round(f2 * lenArrNew(i));
        lenArrNew(i-1) = lenArrNew(i-1) + e1;
        lenArrNew(i+1) = lenArrNew(i+1) + e2;
        lenArrNew(i) = lenArrNew(i) - (e1+e2);
    end

    if p.shock
        mineLenArr = lenArr;
        for kl=1:length(lenArr)
            mineLenArr(kl) = lenArr(kl)*round(rand(1), 2);
        end
        mineArr = [0, lenArr(1:end-1)] + mineLenArr;
        mineArr = cumsum(mineArr);
    end

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
    exper.userdata.cuelist = cueList;
    exper.variables = temp.exper.variables;
    
    cues = repmat(cueList, size(lenArr));
    cues = cues(1, 1:size(lenArr, 2));
    cueids = [1:size(cues,2)];
    exper.userdata.cuestrack = cues;
    exper.userdata.cues = strings(size(posArr(:,2:end)));
    exper.userdata.cueids = zeros(size(posArr(:,2:end)));
    n_start = 1;
    n_end = window;
    for i=1:p.nWorlds
        exper.userdata.cues(i,:) = cues(n_start : n_end);
        exper.userdata.cueids(i,:) = cueids(n_start : n_end);
        n_start = n_start + window - p.overlap;
        n_end = n_end + window - p.overlap;
    end
    
    exper.userdata.nWorlds = p.nWorlds;
    exper.userdata.overlaps = p.overlap;
    % exper.userdata.positions = posArr;
    exper.userdata.postrack = lenArr;
    exper.userdata.postrans = lenArrNew;
    if p.shock
        exper.userdata.minepos = mineArr;
    end
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
    cueWalls = struct(cueList{1},[]);
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
            for j=1:length(cueList)
                if strcmp(worlds{i}.name, cueList{j})
                    cueWalls.(cueList{j}) = temp.exper.worlds{i}.objects{1}.copyItem;
                elseif strcmp(worlds{i}.name, cueList{j})
                    cueWalls.(cueList{j}) = temp.exper.worlds{i}.objects{1}.copyItem;
                end
            end
        end
    end
    
%     exper.userdata.cues = posArr(:,2:end);
%     exper.userdata.cues = strings(size(posArr, 1), size(posArr, 2)-1);
    % add new worlds and each will have a different cue
	for w=1:p.nWorlds;
        % add a new world
%         tempWorld.name = cueList{w};
        addWorld(exper, tempWorld);
        exper.worlds{end}.name = sprintf('Arena_%i', w);
        % exper.worlds{end}.userdata = [];
%         exper.worlds{w}.name = sprintf('%s', cueList{w});
        % add the arena floor ro the new world
        addObject(exper.worlds{w}, arenaFloor);
        exper.worlds{w}.objects{end}.height = posArr(w,end);
        exper.worlds{w}.objects{end}.y = repmat(posArr(w,end)/2, [2,1]);
        % add the right cue walls to the new world
        for o=1:size(posArr, 2)-1
%             cueInd = 2 - mod(o, 2);
%             addObject(exper.worlds{w}, cueWalls.(cueList{cueInd}));
            
            currentCue = exper.userdata.cues(w, o);
            addObject(exper.worlds{w}, cueWalls.(char(currentCue)));
            
            dis = posArr(w, o+1) - posArr(w, o);
            exper.worlds{w}.objects{end}.width = dis;
            exper.worlds{w}.objects{end}.y = repmat(posArr(w, o) + dis*0.5, [2,1]);
            exper.worlds{w}.objects{end}.tiling = [p.tiling, p.tiling*dis / wallHeight];
        end
    end
    
    % comment out if there's no padding
    n_start = 1;
    n_end = window;
    posArrNew = [];
    for i=1:p.nWorlds
        posArrNew = [posArrNew; [0, cumsum(lenArrNew(n_start : n_end))]];
        n_start = n_start + window - p.overlap;
        n_end = n_end + window - p.overlap;
    end
    % update the positions array with the padded transitions
    exper.userdata.positions = posArrNew;
    
    exper.userdata.positions_ = posArr;
    
    % update the code
    updateCodeText(exper);
    
    % save the experiment if needed
    if p.save
        % save(sprintf('D:/User Folders/Hakan/personal_share/Dropbox/AndermannLab/code/Matlab/ViRMEn/experiments/%s', experName), 'exper');
        save(sprintf('%s.mat', experName), 'exper');
    else
        warning('New experiment is created but not saved.');
    end
    