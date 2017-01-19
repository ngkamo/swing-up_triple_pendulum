%--------------------------------------------------------------------------
% Triple pendulum project: Swinging up part
% Updates:
%   - Retrieve the data of positions and speeds, also the input to the cart
%--------------------------------------------------------------------------
%%% Main file %%%

clear; close all; clc;

%%%%%%%%% DEFINITIONS OF THE PARAMETERS %%%%%%%%%
k1 = 0.5;   k2 = 6;                       % constants for the PD controller
% k1 = 3; k2 = 12;
param = struct('l1',1,'l2',1,'l3',1, ...  % length of the links
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
x0 = [0 0 -0.015 -0.4 -0.015 -0.6 -0.015 -0.6]'; %generate trajectory
% x0 = [0 0 -pi/2 0 -pi/2 0 -pi/2 0 ]';
% x0 = zeros(8,1);

% zhistory1 = zeros(N,8);
% uhistory  = zeros(N,1);
% t_history = zeros(N,1);
zhistory1 = [];
uhistory1  = [];
t_history = [];

%%%%%%%%%%%%%%%%%% ODE SOLVER %%%%%%%%%%%%%%%%%%%
options = odeset('abstol',1e-9,'reltol',1e-9);

xprec = x0;
for i =1:N
    clc;
    fprintf('%d / %d',i,N);
    [t1,z1] = ode45(@triple_pendulum_ODE, [0 dt 0.05], ...
        xprec,options,u,param);
    u = -k1*z1(2,1)-k2*z1(2,2);

    % uhistory(i)    = u;
    % t_history(i)   = t1(2);
    % zhistory1(i,:) = z1(2,:);
    zhistory1 = [zhistory1; z1(2,:)];
    uhistory1 = [uhistory1 u];
    t_history = [t_history t1(2)];
    xprec = z1(2,:);
    if z1(2,1)>=4 || z1(2,1)<=-4
        fprintf('ODE45 terminated, out of bounds');
        break
    end
end

zhistory1 = [x0'; zhistory1];
zhistory1(end,:) = [ ];

% Save trajectory and input u in a file
save('trajectory_history.mat','zhistory1','uhistory1','t_history')

%%%%%%%%%%%%%%% POST PROCESSING %%%%%%%%%%%%%%%%%
% Animation of the results
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

