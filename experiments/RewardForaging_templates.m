function code = RewardForaging_templates
% RewardForaging_templates   Code for the ViRMEn experiment RewardForaging_templates.
%   code = RewardForaging_templates   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT



% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)    
    % --- Initialize and set up serial communication with Arduino ---%
    vr.arduino_data = [];
    vr.arduino_serial = arduinoOpen(6);
    

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    vr.val = arduinoReadQuad(vr.arduino_serial);



% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    arduinoClose(vr.arduino_serial);
