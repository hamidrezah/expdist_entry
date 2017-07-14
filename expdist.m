%BINLOCALIZATIONS   Apply rigid transform to the point set and invoke 
%                   executive to evaluate Bhattacharya cost function
%
% SYNOPSIS:
%   D = expdist(S, M, angle, t1, t2)
%
% PARAMETERS:
%   M
%      The first particle (struct with points and sigma as fields
%   ysize
%      The second particle (struct with points and sigma as fields
%   angle
%      in-plane rotation angle to be applied to M
%   [t1, t2]
%      2D translation paramteres 
%
% (C) Copyright 2017               Quantitative Imaging Group
%     All rights reserved          Faculty of Applied Physics
%                                  Delft University of Technology
%                                  Lorentzweg 1
%                                  2628 CJ Delft
%                                  The Netherlands
% Hamidreza Heydarian, Feb 2017

function D = expdist(M, S, angle, t1, t2)

    % rotation matrix
    R = [cos(angle) -sin(angle); sin(angle) cos(angle)];
    % translation vector
    t = [t1 t2];
    % transform the model
    Mt.points = M.points * R' + repmat(t, size(M.points,1), 1);
    Mt.sigma = M.sigma;
    
    % compute the Bhatacharya cost function
    D = mex_expdist(Mt.points, S.points, Mt.sigma, S.sigma);
    
end