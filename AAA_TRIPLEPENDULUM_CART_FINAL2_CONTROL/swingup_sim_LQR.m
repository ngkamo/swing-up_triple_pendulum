%--------------------------------------------------------------------------
% Triple pendulum project: Swinging up part
% Updates:
%   - Retrieve the data of positions and speeds, also the input to the cart
%--------------------------------------------------------------------------
%%% Main file %%%

close all; clc;

%%%%%%%%% DEFINITIONS OF THE PARAMETERS %%%%%%%%%
k1 = 3;   k2 = 12;              % constants for the PD controller
param = struct('l1',1,'l2',1,'l3',1, ...        % length of the links
        'm1',1,'m2',1,'m3',1,'M',1,....   % masses
        'g',9.8);
u=0;

%%%%% SETTING PARAMETERS FOR THE ODE SOLVER %%%%%
init_t = 0;
final_t = 15;
dt = 0.01;
N = (final_t-init_t)/dt;
t_span = [init_t:dt:final_t-dt];

%%%%%%%%%%%%% INITIAL CONDITIONS %%%%%%%%%%%%%%%%
x0 = [0.0   0.0166   -3.1366    0   -3.063    0   -3.1316   0]';
% zhistory = zeros(N,8);
% uhistory = zeros(N,1);
t_history = zeros(N,1);

%%%%%%%%%%%%% TRAJECTORY TREATMENT %%%%%%%%%%%%%%
%%
load('trajectory_history_undersamp2.mat')

zhistory1_reversed = zeros(size(zhistory1));
uhistory1_reversed = zeros(size(uhistory));
for i = 1:size(zhistory1_reversed,1)
    zhistory1_reversed(i,:) = zhistory1(end-i+1,:);
    uhistory1_reversed(i) = uhistory(end-i+1);
end

zhistory1_reversed(:,2) = -zhistory1_reversed(:,2);
zhistory1_reversed(:,4) = -zhistory1_reversed(:,4);
zhistory1_reversed(:,6) = -zhistory1_reversed(:,6);
zhistory1_reversed(:,8) = -zhistory1_reversed(:,8);

% x3 = zhistory1_reversed(1300,:);
% x4 = zhistory1_reversed(1301,:);

% figure(1)
% yyaxis left
% plot(t_span,zhistory1_reversed(:,1),'LineWidth',2)
% ylabel('Position of the cart [m]')
% set(gca, 'FontSize', 13, 'LineWidth', 1, ...
%     'XMinorTick','on', 'YMinorTick','on', ...
%     'XGrid','on', 'YGrid','on', ...
%     'FontName','Roboto Condensed', ...
%     'TickLength',[0.02 0.02]);
%
% yyaxis right
% plot(t_span,[zhistory1_reversed(:,3) zhistory1_reversed(:,5) zhistory1_reversed(:,7)],'LineWidth',2)
% ylabel('Angles of the links [rad]')
% set(gca, 'FontSize', 13, 'LineWidth', 1, ...
%     'XMinorTick','on', 'YMinorTick','on', ...
%     'XGrid','on', 'YGrid','on', ...
%     'FontName','Roboto Condensed', ...
%     'TickLength',[0.02 0.02]);
% legend({'$x_{cart}$' '$\theta_1$' '$\theta_2$' '$\theta_3$'},'Interpreter','latex','FontSize', 14,'Location','southeast')
% title('Position and angles of the triple pendulum')
% set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
%
% print('position_angle_history','-dpng','-r300');
%%
%%%%%%%%%%%%%%%% LQR CONTROLLER  %%%%%%%%%%%%%%%%
x1 = [0 0 -pi 0 -pi 0 -pi 0]';
u1 = 0;
K1 = LQR_controller(x1,u1);
% K1 = zeros(1,8);

%%%%%%%%%%%%%%%%%% ODE SOLVER %%%%%%%%%%%%%%%%%%%

xprec = zhistory1_reversed(1,:)';  % x0

options = odeset('abstol',1e-9,'reltol',1e-9);
for i = 1:N
    clc
    i
    [t1,z1] = ode113(@three_dof_arm_cart_dyn_for_ODE_up, [0 dt 0.05], ...
        xprec,options,u,param);
    % u = -k1*z1(2,1)-k2*z1(2,2);
    % u = -K1*(z1(2,:)-[0 0 pi 0 pi 0 pi 0])';
    if i<=1150
        u = -K1*(z1(2,:)-zhistory1_reversed(i,:))' + uhistory1_reversed(i);
    else
        u = uhistory1_reversed(i);
    end
    uhistory(i) = u;
    zhistory(i,:) = z1(2,:);
    xprec = z1(2,:);
    
    if z1(2,1)>=4 || z1(2,1)<=-4
      fprintf('ODE113 terminated, out of bounds');
      break
    end
end

% zhistory = [x0'; zhistory];
% zhistory(end,:) = [ ];

%%%%%%%%%%%%%%%% POST-PROCESSING %%%%%%%%%%%%%%%%
%%
% figure(2)
% yyaxis left
% plot(t_span(1:i),[zhistory(1:i,1) zhistory(1:i,3) zhistory(1:i,5) zhistory(1:i,7)],'LineWidth',2)
% ylabel('Generalized coordinates of the pendulum')
% set(gca, 'FontSize', 13, 'LineWidth', 1, ...
%     'XMinorTick','on', 'YMinorTick','on', ...
%     'XGrid','on', 'YGrid','on', ...
%     'FontName','Roboto Condensed', ...
%     'TickLength',[0.02 0.02]);
%
% yyaxis right
% plot(t_span(1:i),[zhistory1_reversed(1:i,1) zhistory1_reversed(1:i,3) zhistory1_reversed(1:i,5) zhistory1_reversed(1:i,7)],'LineWidth',2)
% ylabel('Signal to track')
% set(gca, 'FontSize', 13, 'LineWidth', 1, ...
%     'XMinorTick','on', 'YMinorTick','on', ...
%     'XGrid','on', 'YGrid','on', ...
%     'FontName','Roboto Condensed', ...
%     'TickLength',[0.02 0.02]);
% legend({'$x_{cart}$' '$\theta_1$' '$\theta_2$' '$\theta_3$'},'Interpreter','latex','FontSize', 14,'Location','southeast')
% title('Position and angles of the triple pendulum')
% set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');

%%
figure(2)
hold on
p1 = plot(t_span(1:i),[zhistory(1:i,1) zhistory(1:i,3) zhistory(1:i,5) zhistory(1:i,7)],'r','LineWidth',2);
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);

p2 = plot(t_span(1:i),[zhistory1_reversed(1:i,1) zhistory1_reversed(1:i,3) zhistory1_reversed(1:i,5) zhistory1_reversed(1:i,7)],'--b','LineWidth',2);
legend([p1(1) p2(1)],'Generalized coordinates','Signal to track','Location','southeast')
xlabel('Time [s]')
ylabel('Position [m] and angles [rad]')
title('POSITION')
hold off

figure(3)
hold on
p3 = plot(t_span(1:i),[zhistory(1:i,2) zhistory(1:i,4) zhistory(1:i,6) zhistory(1:i,8)],'r','LineWidth',2);
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);

p4 = plot(t_span(1:i),[zhistory1_reversed(1:i,2) zhistory1_reversed(1:i,4) zhistory1_reversed(1:i,6) zhistory1_reversed(1:i,8)],'--b','LineWidth',2);
legend([p3(1) p4(1)],'Generalized coordinates','Signal to track','Location','southeast')
xlabel('Time [s]')
ylabel('Position [m] and angles [rad]')
title('SPEED')
hold off

%%
figure(4)
zerror = abs(zhistory - zhistory1_reversed);
i_end = N;
plot(t_span(1:i_end),[zerror(1:i_end,2) zerror(1:i_end,4) zerror(1:i_end,6) zerror(1:i_end,8)],'LineWidth',1.5);
legend({'$x_{cart}$' '$\theta_1$' '$\theta_2$' '$\theta_3$'},'Interpreter','latex','FontSize', 14)
title('Numerical simulation','FontSize',14)
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
% axis([0 12 0 0.7])
xlabel('Time [s]')
ylabel('Error (absolute value)')
print('LQR4','-dpng','-r200');
