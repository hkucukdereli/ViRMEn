function vr = trialConditions(vr, cueType, varargin)
% handle the conditions
% initialize the trial state as 0

    p = inputParser;
    addOptional(p, 'Pavlovian', 0, @isnumeric);
    addOptional(p, 'Operant', 0, @isnumeric);
    parse(p, varargin{:});
    p = p.Results;
    
    if p.Pavlovian == 0 & p.Operant == 0
        error('Both Pavlovian and Operant frequency cannot be 0.');
    end
    
    conditions = {'Pavlovian', 'Operant'};
    % pick a condition
    sumP = (p.Pavlovian+p.Operant);
    c = sum(rand >= cumsum([0, p.Pavlovian/sumP, p.Operant/sumP]));


    
        % get the cue boundaries
    if strcmp(vr.exper.userdata.cueOrder{1}, vr.cueType)
        vr.positions = reshape(vr.exper.userdata.positions(1:end), 2,[])';
    end
    if strcmp(vr.exper.userdata.cueOrder{2}, vr.cueType)
        vr.positions = reshape(vr.exper.userdata.positions(2:end), 2,[])';
    end
        