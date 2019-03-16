function code = defaultVirmenCode
% defaultVirmenCode   Code for the ViRMEn experiment defaultVirmenCode.
%   code = defaultVirmenCode   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.


% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT



% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
%     % --- Initialize and set up DAQ ---%
%     % reset and connect to DAQ board
%     daqreset;   
%     vr.ai = analoginput('nidaq', 'dev1');
%     
%     % start analog input channels 0 and 1
%     addchannel(vr.ai, 0:1);
%     % start analog output channel 0
%     addchannel(vr.ao, 0);
%     
%     % define the sampling rate to 1kHz and set the duration to be unlimited
%     set(vr.ai,'samplerate',1000,'samplespertrigger',inf)
%     
%     % set the buffering window to be 8 ms long - shorter than a single ViRMEn refresh cycle
%     set(vr.ai,'bufferingconfig',[8 100]);
%     
%     % define a temporary log file to be deleted at the end of the experiment
%     set(vr.ai,'loggingmode','Disk');
%     vr.tempfile = [tempname '.log'];
%     set(vr.ai,'logfilename',vr.tempfile);
%     % start acquisition from the analog input object
%     start(vr.ai);
    
    % --- Initialize and set up serial communication with Arduino ---%
    vr.arduino_data = [];
    vr.arduino_serial = arduinoOpen(6);
    

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
    vr.val = arduinoReadQuad(vr.arduino_serial);



% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    arduinoClose(vr.arduino_serial);