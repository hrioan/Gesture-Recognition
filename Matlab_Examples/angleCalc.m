function [ angle ] = angleCalc( right, center, left )
% Calculates the angle between joints 
% right, center and left are 2-d vectors

% Substract the center from right and left vectors so as to align the
% central vector to the origin (0,0)

right = right - center;
left = left - center;

% Plot , just for visualization purposes 
% ...

% Calclulate Angle (in degrees)

CosTheta = dot(right, left)/(norm(right)*norm(left));

angle = acos(CosTheta)*180/pi;
end

