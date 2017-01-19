clear; close all; clc;

init_t = 0;
final_t = 10;
dt = 0.001;
N = (final_t-init_t)/dt;
t_span = linspace(init_t, final_t, N);

x0 = [0 0 0 0 2 0 2 0]';

x = zeros(8,N);
x(:,1) = x0;

% ODE solver
options=odeset('abstol',1e-9,'reltol',1e-9);
[t,y] = ode45(@four_dof_arm_dyn_for_ODE, t_span, x0, options);

l1 = 1;
l2 = 1;
l3 = 1;
m1 = 1;
m2 = 1;
m3 = 1;
M  = 1;
g  = 9.8;

x=y;

% Playing the result of the simulation
figure; hold on;
for i=1:N-1
    if(mod(i,50)==1)
        clf;
        xcart  = x(i,1);
        theta1 = x(i,3);
        theta2 = x(i,5);
        theta3 = x(i,7);
        p0x=xcart;
        p0y=0;
        x1 = xcart + l1*sin(theta1);
        y1 = -l1*cos(theta1);
        x2 = x1 + l2*sin(theta2);
        y2 = y1 - l2*cos(theta2);
        x3 = x2 + l3*sin(theta3);
        y3 = y2 - l3*cos(theta3);
        px = [p0x x1 x2 x3];
        py = [p0y y1 y2 y3];
        plot(px,py,'bo-','LineWidth',2);
        axis([-4 4 -4 4]);
        axis square
        grid on;
        pause(0.04);
    end
end

% xcart = x(:,1);
% theta1 = x(:,3);
% x1 =  xcart + l1*sin(theta1);
% y1 = -l1*cos(theta1);
% length_rod = (xcart-x1).^2 + y1.^2;
% plot(length_rod)