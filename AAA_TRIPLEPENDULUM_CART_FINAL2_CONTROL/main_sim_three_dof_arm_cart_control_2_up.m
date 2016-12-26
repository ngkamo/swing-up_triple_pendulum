%--------------------------------------------------------------------------
% Triple pendulum project: Swinging up part
% Updates:
%   - Retrieve the data of positions and speeds, also the input to the cart
%--------------------------------------------------------------------------
%%% Main file %%%

clear; close all; clc;

%%%%%%%%% DEFINITIONS OF THE PARAMETERS %%%%%%%%%
k1 = 0.5;   k2 = 6; k3 = 0.5;             % constants for the PD controller
param = struct('l1',1,'l2',1,'l3',1, ...        % length of the links
        'm1',1,'m2',1,'m3',1,'M',1,....   % masses
        'g',9.8);
u=0;

%%%%% SETTING PARAMETERS FOR THE ODE SOLVER %%%%%
init_t = 0;
final_t = 15;
dt = 0.01;
N = (final_t-init_t)/dt;
t_span = init_t:dt:final_t-dt;

%%%%%%%%%%%%% INITIAL CONDITIONS %%%%%%%%%%%%%%%%
x0 = [0 0 -0.01 -0.4 -0.01 -0.6 -0.01 -0.6]';
% x0 = [0 0 -0.2 -0.1 -0.2 -0.4 -0.2 -0.3]'; %good
% x0 = [0 0 -0.1 -0.1 -0.1 -0.1 -0.1 -0.2]';
% x0 = [0 0 -pi/2 0 -pi/2 0 -pi/2 0]';
% x0 = [0 0 -0.1 -0.2 -0.1 -0.4 -0.1 -0.4]';

zhistory1 = zeros(N,8);
uhistory = zeros(N,1);
t_history = zeros(N,1);

% load('LQR_K1.mat');
% K = K1;
% K = LQR_controller([0 0 -pi 0 -pi 0 -pi 0],u);
% K = [-10 -21.85 380.53 21.72 -1277 -59.13 1155  197.655];

%%%%%%%%%%%%%%%%%% ODE SOLVER %%%%%%%%%%%%%%%%%%%
options = odeset('abstol',1e-9,'reltol',1e-9);

xprec = x0;
for i =1:N
    clc
    i
    [t1,z1] = ode113(@three_dof_arm_cart_dyn_for_ODE_up, [0 dt 0.2], ...
        xprec,options,u,param);
%     if z1(2,3)<=-2.53 && z1(2,3)>=-3.75
%         u = -k1*z1(2,1)-k2*z1(2,2)+k3*z1(2,8);
%     else
        u = -k1*z1(2,1)-k2*z1(2,2);
%     end
%     u = -K*(z1(2,:)-[0 0 pi 0 pi 0 pi 0])';
    uhistory(i) = u;
    t_history(i) = t1(2);
    zhistory1(i,:) = z1(2,:);
    xprec = z1(2,:);
    if z1(2,1)>=4 || z1(2,1)<=-4
        fprintf('ODE113 terminated, out of bounds');
        break
    end
end

zhistory1 = [x0'; zhistory1];
zhistory1(end,:) = [ ];

%%%%%%%%%%%%%%% POST PROCESSING %%%%%%%%%%%%%%%%%
% Animation of the simulation
figure(1);
hold on;
for i=1:size(zhistory1,1)
    if(mod(i,5)==1)
        clf;
        p0x = zhistory1(i,1);
        p0y = 0;
        x1  = zhistory1(i,1) - param.l1*sin(zhistory1(i,3));
        y1  = param.l1*cos(zhistory1(i,3));
        x2  = x1 - param.l2*sin(zhistory1(i,5));
        y2  = y1 + param.l2*cos(zhistory1(i,5));
        x3  = x2 - param.l3*sin(zhistory1(i,7));
        y3  = y2 + param.l3*cos(zhistory1(i,7));
        hold on
        plot(p0x,0,'ko','MarkerSize',4);                % pivot point
        plot([p0x x1],[0 y1],'r','LineWidth',2);        % 1st link
        plot([x1 x2],[y1 y2],'b','LineWidth',2);        % 2nd link
        plot([x2 x3],[y2 y3],'g','LineWidth',2);        % 3rd link
        time = annotation('textbox',[0.25 0.85 0.5 0.07],...
            'LineStyle','none',...
            'String',{['time [s]: ',num2str(t_span(i),'%.2f')],...
            ['Initial conditions: xcart=',num2str(x0(1)),' theta1=',num2str(x0(3)),' theta2=',num2str(x0(5)),' theta3=',num2str(x0(7)), ]} );
        axis([-4 4 -4 4]);
        axis square
        grid on
        pause(0.01);
    end
end

% Plotting all the results on graphs
% consigne = linspace(0,1,1000);
figure(2)
plot(t_span,[zhistory1(:,1)])
title('Position of the cart')

[PE, KE] = postprocess_energy_up(zhistory1,param);
% Total energy
figure(3)
PE = 44.1 + PE;
plot(t_span, [KE, PE, KE+PE])
legend('KE','PE','KE+PE')
TE = KE + PE;
TE_diff = diff(TE);
figure(4)
plot(t_span(1:end-1)',TE_diff)
grid on
title('Variation of the total energy')

% save('u_input_reversed.mat',uinput)
% save('trajectory_history1.mat','zhistory1','uhistory','t_history')
