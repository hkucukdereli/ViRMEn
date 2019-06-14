function velocity = moveWithQuadEncoder(vr)

    velocity = [0 0 0 0];

    % Read data from Serial
    val = arduinoReadQuad(vr.arduino_serial);
    vr.arduino_data = val;
    
    % Update velocity
    if ~isfield(vr,'scaling')
        vr.scaling = 2;
    end
    velocity(2) = vr.arduino_data*cos(vr.position(4)) * vr.scaling;

end