function vr = saveDAQData(vr)
    % read and delete the temp file
    fid = fopen(vr.daq.temp_path,'r');
    
    % load the data
    [daq_data, ~] = fread(fid, [length(vr.daq.channels) + 1, inf], 'double');
    
    % organize the data
    vr.daq.data.timestamp = daq_data(1, :);
    for j=1:length(vr.daq.channelnames)
        ch = vr.daq.channelnames{j};
        vr.daq.data.(ch) = daq_data(j + 1, :);
    end
    
    % close the temp file and delete it
    fclose(fid);
    delete(vr.daq.temp_path);