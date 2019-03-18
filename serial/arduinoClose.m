function arduinoClose(open_serial)
%ARDUINOPEN Opens a connection to an Arduino over the COM connection
%   specified by the int com and returns the open connection. Close with
%   fclose(open_serial)
    if ~isempty(open_serial)
        fclose(open_serial);
	fprintf('Arduino is disconnected.\n', com);
    end

end
