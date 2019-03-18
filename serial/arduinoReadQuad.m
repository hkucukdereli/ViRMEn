function val = arduinoReadQuad(open_serial)
%ARDUINOREADQUAD Read from an Arduino over an open connection. The Arduino
%   must be configured to give only the position of the rotary encoder in
%   integers.

    val = 0;
    if ~isempty(open_serial)
        fwrite(open_serial, 0);
        val = fread(open_serial, 1, 'int32');
%         val = fscanf(open_serial, '%d');
    end
end

