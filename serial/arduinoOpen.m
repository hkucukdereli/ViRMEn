function open_serial = arduinoOpen(com)
%ARDUINOPEN Opens a connection to an Arduino over the COM connection
%   specified by the int com and returns the open connection. Close with
%   fclose(open_serial)

    open_serial = serial(sprintf('COM%i', com), 'Terminator', '', 'BaudRate', 115200);
    fopen(open_serial);
    if ~isempty(open_serial)
        fprintf('Arduino is connected to COM%i.\n', com);
    end

end

