function code = tennisCourt
% tennisCourt   Code for the ViRMEn experiment tennisCourt.
%   code = tennisCourt   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT

% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)  
    vr = switchWorlds(vr);

    pos = reshape(exper.userdata.positions, [], 2);
    for i=1:size(pos, 2)
        if strcmp(exper.userdata.cueOrder(mod(i,2)+1), 'CuePlus')
            vr = goodMouse();
        end
        if strcmp(exper.userdata.cueOrder(mod(i,2)+1), 'CueCircle')
        end
    end

    
% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)

