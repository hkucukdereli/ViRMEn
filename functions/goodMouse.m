function vr = goodMouse(vr)
% sends a message to the serial
% ends up triggering reward delivery at the Arduino end
% pulse parameters are set at the Arduino end
    fprintf(vr.arduino_serial , 'R');
end