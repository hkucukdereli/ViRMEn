function vr = saveDAQData(vr)
% read and delete the temp file
    fid = fopen(vr.daq.temp_path,'r');
    [vr.daq.data, ~] = fread(fid, [2,inf], 'double');
    fclose(fid);
    delete(vr.daq.temp_path);