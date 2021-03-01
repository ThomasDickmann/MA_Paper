function [phi] = getAngle(p1_x,p1_y,p2_x,p2_y)
%DIRECTION - finds the angle of a vector (r_i) in the worldframe
%   Based on two points in space, the angle of the vector representing the positive direction of a linkage rod with respect to
%   the positive z-axis of the world frame is found. The direction of the linkage rod
%   coincides with the positive force direction transmitted across it. 
%   The functions inputs are two vectors with pj[pj_x;pj_y] respectively

    %Calculating the vector r from p1 to p1
    delta_x = p2_x - p1_x;
    delta_y = p2_y - p1_y;

    %Angle of vector r in worldframe
    if delta_x > 0
        phi = atan(delta_y/delta_x);
    elseif delta_x < 0
        phi = atan(delta_y/delta_x) - pi;
    elseif (delta_x == 0) && (delta_y > 0)
        phi = pi/2;  
    elseif (delta_x == 0) && (delta_y < 0)
        phi = -pi/2;  
    end
%Test: Conversion to deg
% phi=phi*(360/(2*pi))
end

