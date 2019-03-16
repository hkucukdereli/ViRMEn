function coords2D = transformConical(coords3D)
    % define constants that describe setup geometry
    alpha = 2.0349;
    beta = -0.98988;
    % create an output matrix of the same size as the input
    % first two rows are x and y
    % the third row indicates whether the location should be visible
    coords2D = zeros(size(coords3D));
    % by default, make all points visible
    coords2D(3,:) = true;
    % calculate radius
    r = sqrt(coords3D(1,:).^2 + coords3D(2,:).^2);
    % calculate a scaling factor
    s = 1./(alpha*r + beta*coords3D(3,:));
    % if a point is outside of the screen, set the scaling factor such that the
    % point is plotted at the edge of the screen, and make the point invisible
    % (if all 3 vertices of a triangle are invisible, it is not plotted)
    f = find(s < 0 | r.*s > 1);
    s(f) = 1./r(f);
    coords2D(3,f) = false;
    % calculate x and y components using the scaling factor
    coords2D(1,:) = s.*coords3D(1,:);
    coords2D(2,:) = s.*coords3D(2,:);