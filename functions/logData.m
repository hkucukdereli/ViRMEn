function logData(vr)
    % Get the current timestamp
%     timestamp = now;
    t = clock;
    timestamp = t(6); 
    % Write the timestamp and the position (x & y) and velocity to the log file
    fwrite(vr.fid, [timestamp vr.position(1:2) vr.velocity(1:2)], 'double');