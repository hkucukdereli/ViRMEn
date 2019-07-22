function vr = goodMouse(vr, rewardNum)
    % first construct the message
    rewardMsg = [];
    for i=1:rewardNum
        rewardMsg = [rewardMsg, 'R']
    end
    % send the message out to arduino
    if vr.session.serial
        arduinoWriteMsg(vr.arduino_serial, rewardMsg);
        vr.sessionData.reward = [vr.sessionData.reward, [vr.timeElapsed, vr.position(2) + vr.lastPos]];
        vr.sessionData.rewardDelay = [vr.sessionData.rewardDelay, vr.rewardDelay];
    end