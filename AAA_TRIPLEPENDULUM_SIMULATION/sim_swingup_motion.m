%--------------------------------------------------------------------------
% Triple pendulum project: Swinging up part
%--------------------------------------------------------------------------
%%% Main file %%%

close all; clc;

%%%%%%%%% DEFINITIONS OF THE PARAMETERS %%%%%%%%%
param = struct('l1',1,'l2',1,'l3',1, ...        % length of the links
        'm1',1,'m2',1,'m3',1,'M',1,....   % masses
        'g',9.8);
k1 = 0.5;   k2 = 4;              % constants for the PD controller
u = 0;

load('trajectory_history.mat')


%%%%% SETTING PARAMETERS FOR THE ODE SOLVER %%%%%
init_t = 0;
final_t = 15;
dt = 0.01;
N = (final_t-init_t)/dt;
t_span = [init_t:dt:final_t-dt];

%%%%%%%%%%%%% INITIAL CONDITIONS %%%%%%%%%%%%%%%%
x0 = zhistory1(end,:) + [0 0 0.1 0 0.1 0 0.1 0];
x0(2) = -x0(2);
x0(4) = -x0(4);
x0(6) = -x0(6);
x0(8) = -x0(8);
x0 = x0';

zhistory2 = [];
uhistory = [];

% zhistory1_reversed = zeros(size(zhistory1));
% uhistory1_reversed = zeros(size(uhistory1));
for i = 1:size(uhistory1,2)
    zhistory1_reversed(i,:) = zhistory1(end-i+1,:);
    uhistory1_reversed(i) = uhistory1(end-i+1);
end

zhistory1_reversed(:,2) = -zhistory1_reversed(:,2);
zhistory1_reversed(:,4) = -zhistory1_reversed(:,4);
zhistory1_reversed(:,6) = -zhistory1_reversed(:,6);
zhistory1_reversed(:,8) = -zhistory1_reversed(:,8);

% x0 = zhistory1_reversed(1,:)';% + [0;0;0.1;0;0.1;0;0.1;0];

%%%%%%%%%%%%%%% LQR CONTROLLER  %%%%%%%%%%%%%%%%
x1 = [0 0 -pi 0 -pi 0 -pi 0]';
u1 = 0;
K1 = LQR_controller(x1,u1);

%%%%%%%%%%%%%%%%%% ODE SOLVER %%%%%%%%%%%%%%%%%%%
options = odeset('abstol',1e-9,'reltol',1e-9);

xprec = x0;
for i =1:N
    clc;
    fprintf('%d / %d',i,N);
    [t1,z1] = ode45(@triple_pendulum_ODE, [0 dt 0.05], ...
        xprec,options,u,param);
    zhistory2 = [zhistory2; z1(2,:)];

    if i<= 600
        u = -K1*(z1(2,:)-zhistory1_reversed(i,:))' + uhistory1_reversed(i);
    else
        u = uhistory1_reversed(i);
    end
    xprec = z1(2,:);
    if z1(2,1)>=4 || z1(2,1)<=-4
        fprintf('ODE45 terminated, out of bounds');
        break
    end
end

zhistory2 = [x0'; zhistory2];
zhistory2(end,:) = [ ];

%%%%%%%%%%%%%%% POST PROCESSING %%%%%%%%%%%%%%%%%
% Animation of the simulation
figure(1);
hold on;
for i=1:size(zhistory2,1)
    if(mod(i,5)==1)
        clf;
        p0x = zhistory2(i,1);
        p0y = 0;
        x1  = zhistory2(i,1) - param.l1*sin(zhistory2(i,3));
        y1  = param.l1*cos(zhistory2(i,3));
        x2  = x1 - param.l2*sin(zhistory2(i,5));
        y2  = y1 + param.l2*cos(zhistory2(i,5));
        x3  = x2 - param.l3*sin(zhistory2(i,7));
        y3  = y2 + param.l3*cos(zhistory2(i,7));
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
        pause(0.010);
    end
end
