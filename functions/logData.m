function logData(vr)
    % Get the current timestamp

    % Write the timestamp and the position (x & y) and velocity to the log file
    fwrite(vr.fid, [-1, vr.timeElapsed, vr.position(2), vr.velocity(2), vr.rewardCount], 'double');
