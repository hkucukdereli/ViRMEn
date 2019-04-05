function terminationForSerial(vr)
    % Close the log file
%     fclose(vr.fid);
    
    % Turn off stim if on
    if vr.nTrials
        if vr.trialInfo(vr.nTrials).stimOn
            arduinoWriteMsg(vr.arduino_serial, 'O');
        end
    end
    % Close the open serial port
    arduinoClose(vr.arduino_serial);