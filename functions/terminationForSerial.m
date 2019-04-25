function terminationForSerial(vr)
    % Close the log file
%     fclose(vr.fid);
    
    % Turn off stim if on
    if vr.nTrials
        arduinoWriteMsg(vr.arduino_serial, 'O');
    end
    % Close the open serial port
    arduinoClose(vr.arduino_serial);