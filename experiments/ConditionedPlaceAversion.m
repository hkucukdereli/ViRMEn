function code = ConditionedPlaceAversion
% ConditionedPlaceAversion   Code for the ViRMEn experiment CPPtest2world.
%   code = ConditionedPlaceAversion   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT



% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
    vr.info = loadVirmenInfo('exp');
    vr.com = 6;
    vr = initializationForSerial(vr, vr.com, vr.info.mouse, vr.info.date, vr.info.run);
    
    % create the exeriment worlds
    
    
    vr.trialCount = 0;
    tic;



% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    logData(vr);
    % Check if teleportation is needed
    vr = teleportCheck(vr, 900);
    
    vr = getTimeStamp(vr);
    
%     vr.worlds{vr.currentWorld}
%     vr.exper.variables.cue1


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    terminationForSerial(vr);
