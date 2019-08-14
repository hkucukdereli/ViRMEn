function vr  = badMouse(vr)
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, 'PP');
    end