function data = readVirmenData(path)
    % open the binary file
    fid = fopen(path);
    % read all data from the file into a 5-row matrix
    data = fread(fid, [5 inf], 'double');
    data = data'
    % close the file
    fclose(fid);
    % plot the 2D position information
    % plot(data(2,:),data(3,:));