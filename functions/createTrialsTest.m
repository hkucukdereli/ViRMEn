function params = createTrialsTest(experName, templateName, varargin)
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
%         lens = round(normrnd(p.cueL, p.cueL*0.1, 1, window));
        lens = p.cueL + round(exprnd(250, [1, 2*window])) 
        for k=1:p.nWorlds
            lenArr = [lenArr, lens(randperm(length(lens)))];
        end
    else
        lenArr = round(normrnd(p.cueL, p.cueL*0.2, 1, window * p.nWorlds) + 800);
    end
    
    n_start = 1;
    n_end = window;
    posArr = [];
    for i=1:p.nWorlds
        posArr = [posArr; [0, cumsum(lenArr(n_start : n_end))]];
        n_start = n_start + window - p.overlap;
        n_end = n_end + window - p.overlap;
    end
    
    mines = [];
    for k=1:length(lenArr)
        display(lenArr(k)*rand());
        kmines = [mines, lenArr(k)*rand()];
    end
    
    params = struct('lens',lens, 'lenArr', lenArr, 'posArr',posArr, 'mines',mines);
    
    
%     A = [];
%     count = 0;
%     while count < 100
%         randomN = exprnd(100,1);
%         if randomN < 200000
%             A = [A, randomN];
%             count = count + 1;
%         end
%     end
%     hist(A)
    
    