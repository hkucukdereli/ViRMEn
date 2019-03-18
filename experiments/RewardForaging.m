function code = RewardForaging
% RewardForaging   Code for the ViRMEn experiment tennisCourt.
%   code = tennisCourt   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT

% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
    % parameters to change
    vr.date = '190318';
    vr.mouse = 'HK00';
    vr.run = 1;
    vr.cueType = 'CuePlus';
    vr.conditions = {'Pavlovian', 'Operant'};
    vr.Pavlovian = 1; 
    vr.Operant = 0; 
    if strcmp(vr.exper.userdata.cueOrder{1}, vr.cueType)
        vr.trialstate = 0;
    elseif ~strcmp(vr.exper.userdata.cueOrder{1}, vr.cueType)
        vr.trialstate = 1;
    end
    vr.cueNum = 1;
    
    % initialize the serial for Arduino
    vr = initializationForSerial(vr, 5);
    

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    vr = switchWorlds(vr);
    
    % pick a condition
    sumP = (vr.Pavlovian + vr.Operant);
    c = sum(rand >= cumsum([0, vr.Pavlovian/sumP, vr.Operant/sumP]));
    
    % get the cue boundaries
    dr = round(exprnd(20,1,1), 0); % pick a single number from an exponential dist
    for p=1:length(vr.exper.userdata.positions)-1
        if vr.position(2) > vr.exper.userdata.positions(p)+dr && vr.position(2) < vr.exper.userdata.positions(p+1)
            vr.cueNum = p;
        end
        vr.currentCue = vr.exper.userdata.cueOrder{2-mod(vr.cueNum, 2)};
        if vr.trialstate == 0 && strcmp(vr.currentCue, vr.cueType)
            vr.trialstate = 1;
            if strcmp(vr.conditions(c), 'Pavlovian')
                vr = goodMouse(vr);
            end
        elseif vr.trialstate == 1 && ~strcmp(vr.currentCue, vr.cueType)
            vr.trialstate = 0;
        end
    end
    
    
% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    % close the serial and terminate the experiment
    terminationForSerial(vr);

