function arduinoWriteMsg(open_serial, msg)
% Send a message to the serial
% <msg> is a single character
% 'O': turn on the opto stim
% 'R': give out a reward
% 'S': give out shock pulses

    if ~isempty(open_serial)
        fwrite(open_serial, msg);
    end

end