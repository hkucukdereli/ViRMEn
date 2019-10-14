function [coords2D, out_win2] = fliptransformCyl_NPparab(coords3D)

    % create an output matrix of the same size as the input
    % first two rows are x and y
    % the third row indicates whether the location should be visible

    coords2D = coords3D;

    % [azimuth,elevation,r] =
    % cart2sph(coords3D(1,:),coords3D(2,:),coords3D(3,:));

    hypotxy = hypot(coords3D(1,:),coords3D(2,:));
    % rmaze = hypot(hypotxy,coords3D(3,:));
    elev = atan2(coords3D(3,:),hypotxy);
    azimuth = atan2(coords3D(2,:),coords3D(1,:));

    % height = tan(elevation)*5;
    % azimuth = wrapToPi(azimuth);
    visible = ~(azimuth<-pi/4 & azimuth>(-pi + pi/4));

    xSign = sign(coords3D(1,:));
    ySign = sign(coords3D(2,:));
    azTemp = abs(azimuth);
    azTemp(xSign==-1) = -azTemp(xSign==-1)+pi;

    a = -0.125;
    b = -1*tan(azTemp).*ySign;
    c = 5;

    x = ((-b-sqrt(b.^2 - 4.*a.*c))./(2.*a));
    % x = ((-b-sqrt(b - 4.*a.*c))./(2.*a));
    x = x.*xSign;

    x(x<-20) = -20;
    x(x>20) = 20;
    y = a.*x.^2;

    throw_ratio = 1.39; % for LaserBeam Pro
    proj_dist = -y+20.6;
    screenDist = hypot(x,y+5);
    heightOnScreen = tan(elev).*screenDist;%(coords3D(3,:).*screenDist)./hypotxy;
    projectedImageHeight = (proj_dist./throw_ratio).*(9/16);

    coords2D(1,:) = ((x.*(20.6./(-y+20.6)))./6.0).*(16/9);
    coords2D(2,:) = -1.*(heightOnScreen./projectedImageHeight);
    coords2D(2,coords2D(2,:)<-1) = -1;

    coords2D(3,:) = visible;

end

% function lambda = wrapToPi(lambda)
%     %wrapToPi Wrap angle in radians to [-pi pi]
%     %
%     %   lambdaWrapped = wrapToPi(LAMBDA) wraps angles in LAMBDA, in radians,
%     %   to the interval [-pi pi] such that pi maps to pi and -pi maps to
%     %   -pi.  (In general, odd, positive multiples of pi map to pi and odd,
%     %   negative multiples of pi map to -pi.)
%     %
%     %   See also wrapTo2Pi, wrapTo180, wrapTo360.
% 
%     % Copyright 2007-2008 The MathWorks, Inc.
% 
%     q = (lambda < -pi) | (pi < lambda);
%     lambda(q) = wrapTo2Pi(lambda(q) + pi) - pi;
% end
% 
% function lambda = wrapTo2Pi(lambda)
%     %wrapTo2Pi Wrap angle in radians to [0 2*pi]
%     %
%     %   lambdaWrapped = wrapTo2Pi(LAMBDA) wraps angles in LAMBDA, in radians,
%     %   to the interval [0 2*pi] such that zero maps to zero and 2*pi maps
%     %   to 2*pi. (In general, positive multiples of 2*pi map to 2*pi and
%     %   negative multiples of 2*pi map to zero.)
%     %
%     %   See also wrapToPi, wrapTo180, wrapTo360.
% 
%     % Copyright 2007-2008 The MathWorks, Inc.
% 
%     positiveInput = (lambda > 0);
%     lambda = mod(lambda, 2*pi);
%     lambda((lambda == 0) & positiveInput) = 2*pi;
% end