function terminationForSerial(vr)
    % Close the log file
    fclose(vr.fid);
    
    % Close the open serial port
    arduinoClose(vr.arduino_serial);
%     if exist vr.arduino_serial
%         arduinoClose(vr.arduino_serial);
%     end