function code = RewardForaging
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
    date = '190318';
    mouse = 'HK00';
    run = 1;
    
    % initialize the serial for Arduino
    vr = initializationForSerial(vr, 6, mouse, date, run);
    
    vr.trialstate = 0;
    

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    vr = switchWorlds(vr);

    vr = checkConditions('CuePlus', 'Pavlovian', 1, 'Operant', 0);


    
% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    % close the serial and terminate the experiment
    terminationForSerial(vr);

