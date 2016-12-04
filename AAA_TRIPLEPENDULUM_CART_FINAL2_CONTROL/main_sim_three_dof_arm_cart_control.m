%%% Main file %%%

clear; close all; clc;

%%%%%%%%% DEFINITIONS OF THE PARAMETERS %%%%%%%%%
l1 = 1;     l2 = 1;     l3 = 1;  % length of the links
m1 = 1;     m2 = 1;     m3 = 2;  % masses at the end of each link
M  = 1;                          % mass of the cart
g  = 9.8;   k1 = 0.5;     k2 = 5;
u = [0 0 0 0]';

%%%%% SETTING PARAMETERS FOR THE ODE SOLVER %%%%%
init_t = 0;
final_t = 15;
dt = 0.01;
N = (final_t-init_t)/dt;
% N = 1500;
t_span = [init_t:dt:final_t-dt];

framespersec = 30;
T = 15;
% t_span = [0:0.01:15-0.01];
% u1 = sin(t_span);
% u = [u1; zeros(3,length(t_span))];

%%%%%%%%%%%%% INITIAL CONDITIONS %%%%%%%%%%%%%%%%
x0 = [0 0 pi/2 0 pi/2 0 pi/2 0]';
xcart = sin(t_span);
xspeedcart = cos(t_span);
zhistory = [];
% ODE solver
options = odeset('abstol',1e-9,'reltol',1e-9);
[t,zhistory] = ode45(@three_dof_arm_cart_dyn_for_ODE, t_span, x0,options,u,l1,l2,l3,m1,m2,m3,M,g);
% for i =1:N
%     [t1,z1] = ode45(@three_dof_arm_cart_dyn_for_ODE, [0 0.01 0.1], xprec,options,u,l1,l2,l3,m1,m2,m3,M,g);
%     zhistory = [zhistory; z1(2,:)];
%     u = [-k1*z1(2,1)-k2*z1(2,2) 0 0 0]';
%     xprec = z1(2,:);
% end

% zhistory = [x0'; zhistory];
% zhistory(end,:) = [ ];


%%%%%%%%%%%%%% POST PROCESSING %%%%%%%%%%%%%%
% Animation of the simulation
figure; 
hold on;
for i=1:N
    if(mod(i,50)==1)
        clf;
        p0x = zhistory(i,1);
        p0y = 0;
        x1  = zhistory(i,1) + l1*sin(zhistory(i,3));
        y1  = -l1*cos(zhistory(i,3));
        x2  = x1 + l2*sin(zhistory(i,5));
        y2  = y1 - l2*cos(zhistory(i,5));
        x3  = x2 + l3*sin(zhistory(i,7));
        y3  = y2 - l3*cos(zhistory(i,7));
        hold on
        plot(p0x,0,'ko','MarkerSize',4);                % pivot point
        plot([p0x x1],[0 y1],'r','LineWidth',2);        % 1st link
        plot([x1 x2],[y1 y2],'b','LineWidth',2);        % 2nd link
        plot([x2 x3],[y2 y3],'g','LineWidth',2);        % 3rd link
        time = annotation('textbox',[0.25 0.85 0.5 0.07],...
        'LineStyle','none',...
        'String',{['time [s]: ',num2str(t(i),'%.2f')],...
        ['Initial conditions: xcart=',num2str(x0(1)),' theta1=',num2str(x0(3)),' theta2=',num2str(x0(5)),' theta3=',num2str(x0(7)), ]} );
        axis([-4 4 -4 4]);
        axis square
        grid on
        pause(0.01);
    end
end

% Plotting all the results on graphs
figure(2)
plot(t_span,zhistory(:,1))