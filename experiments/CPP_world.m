function code = CPP_world
% CPPtest2world   Code for the ViRMEn experiment CPPtest2world.
%   code = CPPtest2world   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT



% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
    date = '190226';
    mouse = 'HK00';
    run = 1;
    vr = initializationForSerial(vr, 6, mouse, date, run);
    
    vr.trialCount = 0;



% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    logData(vr);
    % Check if teleportation is needed
    %%%% use a new teleport method....switchWorlds
    
    vr = getTimeStamp(vr);
   
    


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    terminationForSerial(vr);
