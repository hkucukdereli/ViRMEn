function vr = initializationForSerial(vr, com)
    fprintf('Initializing...\n');
    % open or create binary file for writing and store its file ID in vr
%     filename = sprintf('virmenLog_%s_%s_%i.dat', vr.date, vr.mouse, vr.run);
%     vr.fid = fopen(filename, 'w');
    
    % --- Initialize and set up serial communication with Arduino ---%
    vr.arduino_data = [];
    try
        vr.arduino_serial = arduinoOpen(com);
        fprintf('Arduino is connected to COM%i.\n', com);
    catch
        fprintf('COM%i is not available or Arduino is not connected. Continuing without serial...\n', com);
    end
end
