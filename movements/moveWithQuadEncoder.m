function velocity = moveWithQuadEncoder(vr)

    velocity = [0 0 0 0];

    % Read data from Serial
    val = arduinoReadQuad(vr.arduino_serial);
    vr.arduino_data = val;
    
    % Update velocity
    velocity = [0 vr.arduino_data*cos(vr.position(4)) 0 0];

end