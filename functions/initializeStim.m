function vr = initializeStim(vr)
    % Get the index of the stim screen
    ind = vr.worlds{vr.currentWorld}.objects.indices.stimScreen;
    % Determine the indices of the first and last vertex
    vertexFirstLast = vr.worlds{vr.currentWorld}.objects.vertices(ind,:);
    % Create an array of all vertex indices
    vr.stimInd = vertexFirstLast(1):vertexFirstLast(2);