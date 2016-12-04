%%% Main file %%%

clear; close all; clc;

%%%%%%%%% DEFINITIONS OF THE PARAMETERS %%%%%%%%%
l1 = 1;     l2 = 1;     l3 = 1;  % length of the links
m1 = 1;     m2 = 1;     m3 = 1;  % masses at the end of each link
M  = 1;                          % mass of the cart
g  = 9.8;
u = [0 0 0 0];

%%%%% SETTING PARAMETERS FOR THE ODE SOLVER %%%%%
init_t = 0;
final_t = 15;
dt = 0.01;
N = (final_t-init_t)/dt;
t_span = [init_t:dt:final_t-dt];

% Initial conditions
x0 = [0 0 pi/2 0 pi/2 0 pi/2+0.1 0]';

% ODE solver
options = odeset('abstol',1e-9,'reltol',1e-9);
[t,z] = ode45(@three_dof_arm_cart_dyn_for_ODE, t_span, x0,options,u,l1,l2,l3,m1,m2,m3,M,g);
% [t,z] = ode113(@three_dof_arm_cart_dyn_for_ODE, t_span, x0, options,u,l1,l2,l3,m1,m2,m3,M,g);

%%%%%%%%% POSTPROCESS %%%%%%%%%
% Animation of the results
figure; hold on;
for i=1:N
%     if(mod(i,50)==1)
        clf;
        p0x = z(i,1);
        p0y = 0;
        x1  = z(i,1) + l1*sin(z(i,3));
        y1  = -l1*cos(z(i,3));
        x2  = x1 + l2*sin(z(i,5));
        y2  = y1 - l2*cos(z(i,5));
        x3  = x2 + l3*sin(z(i,7));
        y3  = y2 - l3*cos(z(i,7));
        hold on
        plot(p0x,0,'ko','MarkerSize',4); %pivot point
        plot([p0x x1],[0 y1],'r','LineWidth',2);
        plot([x1 x2],[y1 y2],'b','LineWidth',2);
        plot([x2 x3],[y2 y3],'g','LineWidth',2);
        time = annotation('textbox',[0.25 0.85 0.5 0.07],...
            'LineStyle','none',...
            'String',{['time [s]: ',num2str(t_span(i),'%.2f')],...
            ['Initial conditions: xcart=',num2str(x0(1)),' theta1=',num2str(x0(3)),' theta2=',num2str(x0(5)),' theta3=',num2str(x0(7)), ]} );
        axis([-4 4 -4 4]);
        axis square
        grid on
        pause(0.01);
%     end
end

% Plots
p0x = z(:,1);
x1  = z(:,1) + l1*sin(z(:,3));
y1  = -l1*cos(z(:,3));
x2  = x1 + l2*sin(z(:,5));
y2  = y1 - l2*cos(z(:,5));
x3  = x2 + l3*sin(z(:,7));
y3  = y2 - l3*cos(z(:,7));

xd = z(:,2);
x1d = xd + l1*cos(z(:,3)).*z(:,4);
y1d = l1*sin(z(:,3)).*z(:,4);
x2d = x1d + l2*cos(z(:,5)).*z(:,6);
y2d = y1d + l2*sin(z(:,5)).*z(:,6);
x3d = x2d + l3*cos(z(:,7)).*z(:,8);
y3d = y2d + l3*sin(z(:,7)).*z(:,8);

v1sq = x1d.^2 + y1d.^2;
v2sq = x2d.^2 + y2d.^2;
v3sq = x3d.^2 + y3d.^2;

% KINETIC AND POTENTIAL ENERGY COMPUTATION
% Checking if the total energy is constant:
% - energy difference can not be better than the ode tolerance.
% - not true if system is actuated or there are dissipative forces.
% figure(2)
PE = m1*g*y1 + m2*g*y2 + m3*g*y3;
KE = 0.5*M*xd.^2 + 0.5*m1*v1sq + 0.5*m2*v2sq + 0.5*m3*v3sq;
% plot(t_span,KE);
% 
% % Total energy
TE = KE + PE;
TE_diff = diff(TE);
figure(3)
plot(t_span(1:end-1),TE_diff)
grid on
title('Variation of the total energy')

% Plot position and speed
figure(4)
plot(t_span,[z(:,1) z(:,2)])
legend('position','speed')
grid on