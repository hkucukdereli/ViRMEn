function vr  = badMouse(vr)
    fprintf(' \bShock count: %i\n', vr.shockCount);
    vr.shockCount = vr.shockCount + 1;
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, 'PP');
    else
        fprintf('No shock is given. Serial is not connected.\n');
    end