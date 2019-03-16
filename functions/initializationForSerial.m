function vr = initializationForSerial(vr, com, mouse, date, run)
    % open or create binary file for writing and store its file ID in vr
    c = clock;
    filename = sprintf('virmenLog_%s_%s_%i_%i-%i.dat', date, mouse, run, c(4), c(5));
    vr.fid = fopen(filename, 'w');
    
    % --- Initialize and set up serial communication with Arduino ---%
    vr.arduino_data = 0;
    try
        vr.arduino_serial = arduinoOpen(com);
    catch
        fprintf('COM%i is not available or Arduino is not connected. Continuing without serial...\n', com);
    end
end
