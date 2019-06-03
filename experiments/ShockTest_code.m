function code = ShockTest_code
% ShockTest_code   Code for the ViRMEn experiment tennisCourt.
% code = Conditioning   Returns handles to the functions that ViRMEn
% executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT

% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
    
    vr.session = struct('serial', true,...
                        'com', 5);

    if vr.session.serial
        serialFix;
        vr = initializationForSerial(vr, vr.session.com);
    end
   
    vr.worlds{vr.currentWorld}.surface.visible(1,:) = 0;
    

    fprintf('Press spacebar to start the experiment.\n');
    
% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    
    if vr.keyPressed == 32
        display('SHOCK');
        arduinoWriteMsg(vr.arduino_serial, 'PP');
    end


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)

    if vr.session.serial
        terminationForSerial(vr);
    end
