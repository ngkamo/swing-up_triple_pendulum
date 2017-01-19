%--------------------------------------------------------------------------
% This function computes the potential and the kinectic energy during the 
% simulation of the triple pendulum
% Edited on 13th December 2016
%--------------------------------------------------------------------------

function [PE, KE] = postprocess_energy(z,param)
l1 = param.l1;
l2 = param.l2;
l3 = param.l3;
m1 = param.m1;
m2 = param.m2;
m3 = param.m3;
M  = param.M;
g  = param.g;
% p0x = z(:,1);
% x1  = z(:,1) + l1*sin(z(:,3));
% y1  = -l1*cos(z(:,3));
% x2  = x1 + l2*sin(z(:,5));
% y2  = y1 - l2*cos(z(:,5));
% x3  = x2 + l3*sin(z(:,7));
% y3  = y2 - l3*cos(z(:,7));

% xd = z(:,2);
% x1d = xd + l1*cos(z(:,3)).*z(:,4);
% y1d = l1*sin(z(:,3)).*z(:,4);
% x2d = x1d + l2*cos(z(:,5)).*z(:,6);
% y2d = y1d + l2*sin(z(:,5)).*z(:,6);
% x3d = x2d + l3*cos(z(:,7)).*z(:,8);
% y3d = y2d + l3*sin(z(:,7)).*z(:,8);

% v1sq = x1d.^2 + y1d.^2;
% v2sq = x2d.^2 + y2d.^2;
% v3sq = x3d.^2 + y3d.^2;

x = z(:,1);      xd = z(:,2);
theta1 = z(:,3); theta1d = z(:,4);
theta2 = z(:,5); theta2d = z(:,6);
theta3 = z(:,7); theta3d = z(:,8);

p1 = [x - l1/2*sin(theta1), l1/2*cos(theta1)];
p2 = [x - l1*sin(theta1) - l2/2*sin(theta2), l1*cos(theta1) + l2/2*cos(theta2)];
p3 = [x - l1*sin(theta1) - l2*sin(theta2) - l3/2*sin(theta3), l1*cos(theta1) + l2*cos(theta2) + l3/2*cos(theta3)];

x1d = xd - l1/2*cos(theta1).*theta1d;
y1d = - l1/2*sin(theta1).*theta1d;
x2d = xd - l1*cos(theta1).*theta1d - l2/2*cos(theta2).*theta2d;
y2d = - l1*sin(theta1).*theta1d - l2/2*sin(theta2).*theta2d;
x3d = xd - l1*cos(theta1).*theta1d - l2*cos(theta2).*theta2d - l3/2*cos(theta3).*theta3d;
y3d = - l1*sin(theta1).*theta1d - l2*sin(theta2).*theta2d - l3/2*sin(theta3).*theta3d;

p1d = [x1d y1d];
p2d = [x2d y2d];
p3d = [x3d y3d];

%%%%%%%%%% POTENTIAL AND KINETIC ENERGY %%%%%%%%%%
PE = m1*g*p1(:,2) + m2*g*p2(:,2) + m3*g*p3(:,2) + 44.1;

KE = 0.5 * (M*xd.^2 + m1*sum(p1d.^2,2) + m2*sum(p2d.^2,2) + m3*sum(p3d.^2,2)) + ...
    0.5 * (m1*l1^2/12*theta1d.^2 + m2*l2^2/12*theta2d.^2 + m3*l3^2/12*theta3d.^2);