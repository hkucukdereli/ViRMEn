function vr = initializationForSerial(vr)
    serialFix;
    if vr.session.serial
        fprintf('Initializing...\n');

        % --- Initialize and set up serial communication with Arduino ---%
        vr.arduino_data = [];
        try
            vr.arduino_serial = arduinoOpen(vr.session.com);
            fprintf('Arduino is connected to COM%i.\n', vr.session.com);
        catch
            fprintf('COM%i is not available or Arduino is not connected. Continuing without serial...\n', vr.session.com);
        end
        if vr.session.input
            vr.arduino_serial_input = arduinoOpen(vr.session.input_com);
            fprintf('Input device is connected to COM%i.\n', vr.session.input_com);
        end
    end
