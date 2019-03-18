function vr = checkConditions(cue, 'Pavlovian', 1, 'Operant', 0)
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
    p.Pavlovian=2;p.Operant=4;
    sumP = (p.Pavlovian+p.Operant);
    c = sum(rand >= cumsum([0, p.Pavlovian/sumP, p.Operant/sumP]))

    if strcmp(vr.exper.userdata.cueOrder{1}, cue)
        pos = reshape(vr.exper.userdata.positions(1:end), 2,[])';
    else if strcmp(vr.exper.userdata.cueOrder{2}, cue)
        pos = reshape(vr.exper.userdata.positions(2:end), 2,[])';
    end
    
    for i=1:size(pos, 1)
        if trialstate == 0 & vr.position(2) > pos(i,1) & vr.position(2) < pos(i,2)
            if conditions{c} == 'Pavlovian'
                goodMouse(vr);
            end
%             if conditions{c} == 'Operant'
%                 ...
%             end
            vr.trialstate = 1;
        else if trialstate == 1 & vr.position(2) > pos(i,2)
                vr.trialstate = 0;
        end
    end
