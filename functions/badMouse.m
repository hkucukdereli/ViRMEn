function badMouse(vr)
% sends a message to the serial
% ends up triggering a sequence of shocks at the Arduino end
% pulse parameters are set at the Arduino end
    fprintf(vr.arduino_serial , 'S');
end