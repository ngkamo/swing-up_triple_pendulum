% Plots used for the report

%% Input
plt = Plot(t_span,uinput_reversed(1,:))
plt.XLabel = 'Time, t [s]';
plt.YLabel = 'Input force [N]';
% plt.Title  = 'Input history of the PD controller';
plt.FontName = 'Roboto';
plt.BoxDim = [4, 3];
plt.XGrid = 'on';
plt.YGrid = 'on';

%% Angles, position
close all
plt2 = Plot(t_span,[zhistory(:,1) zhistory(:,3) zhistory(:,5) zhistory(:,7)])
% lgd1 = legend('$x_{cart}$','$\theta_1$','$\theta_2$','$\theta_3$')
plt2.Legend = {'x_{cart}','\theta_1','\theta_2','\theta_3'};
% set(lgd1,'Interpreter','latex','FontSize',12);
title('Positions of the cart and angles of  links')
xlabel('Time [s]')
plt2.BoxDim = [4, 3];
plt2.LegendBox = 'on';
grid on

%% Variation of the total energy free falling simulation (check model)
close
TE_diff = diff(KE+PE);
figure('Units','centimeters')
plot(t_span(1:end-1),TE_diff,'Linewidth',2)
xlabel('Time [s]');
ylabel('\partial E_{total}/\partial t');
title('Variation of the total energy');
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 14 8]);   % size of the figure
set(gca, 'FontSize', 11, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('variation_totalenergy','-dpng','-r300');

%% Kinetic & potential energy free falling simulation
close
[PE, KE] = postprocess_energy(zhistory1,param)
figure('Units','centimeters')
plot(t_span, [KE, PE, KE+PE], 'LineWidth', 2);
legend('kinetic', 'potential', 'total');
xlabel('Time [s]');
ylabel('Energy [J]');
title('Kinetic and potential energy during the simulation')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 13 9.75]);
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'YLim', [0 100], ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('sim_generate_kineticpotential_energy','-dpng','-r300');

%%%%%%%%%%%%%%%%%%%% PD CONTROLLED TRIPLE PENDULUM %%%%%%%%%%%%%%%%%%%%%%%%
%% Kinetic & potential energy PD controller simulation
close
figure('Units','centimeters')
plot(t_span, [KE, PE, KE+PE], 'LineWidth', 2);
legend('kinetic', 'potential', 'total');
xlabel('Time [s]');
ylabel('Energy [J]');
title('Kinetic and potential energy during the simulation')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 11 9]);
set(gca, 'FontSize', 11, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('kineticpotential_energy_PD','-dpng','-r300');

%% Input of the PD controller
close
figure('Units','centimeters')
plot(t_span, uhistory1_reversed, 'LineWidth', 2);
% legend('kinetic', 'potential', 'total');
xlabel('Time [s]');
ylabel('Force [N]');
title('Force u of the PD controller')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 11 9]);
set(gca, 'FontSize', 14, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('sim_generate_uinputrev_PD','-dpng','-r300');

%% Position of the cart and angles of links
close
figure('Units','centimeters')
plot(t_span, [zhistory1(:,1) zhistory1(:,3) zhistory1(:,5) zhistory1(:,7)], 'LineWidth',2)
lgd1 = legend({'$x_{cart}$' '$\theta_1$' '$\theta_2$' '$\theta_3$'},'Interpreter','latex','FontSize',15);
title('Positions of the cart and angles of links')
xlabel('Time [s]')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 12 9]);
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('sim_generate_position_angle_cart','-dpng','-r300');
% print('sim_generate_position_angle_cart','-depsc')

%% Position and angles of the cart
close
figure('Units','centimeters')
yyaxis left
plot(t_span,zhistory1(:,1),'LineWidth',2)
ylabel('Position of the cart [m]')
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);

yyaxis right
% zhistory_res1 = rad2deg(zhistory_res(:,[3 5 7]))
plot(t_span,[zhistory1(:,3) zhistory1(:,5) zhistory1(:,7)],'LineWidth',2)
ylabel('Angles of the links [rad]')
xlabel('Time [s]')
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
legend({'$x_{cart}$' '$\theta_1$' '$\theta_2$' '$\theta_3$'},'Interpreter','latex','FontSize', 14,'Location','southeast')
title('Position and angles')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 12 9]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');

print('sim_generate_position_angle_cart','-dpng','-r300');

%% Speed and angular of the cart
close
figure('Units','centimeters')
yyaxis left
plot(t_span,zhistory1(:,2),'LineWidth',2)
ylabel('Position of the cart [m]')
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);

yyaxis right
% zhistory_res1 = rad2deg(zhistory_res(:,[3 5 7]))
plot(t_span,[zhistory1(:,4) zhistory1(:,6) zhistory1(:,8)],'LineWidth',2)
ylabel('Angles of the links [rad]')
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
legend({'$\dot x_{cart}$' '$\dot \theta_1$' '$\dot \theta_2$' '$\dot \theta_3$'},'Interpreter','latex','FontSize', 14,'Location','southeast')
title('Speed and angular speed')
xlabel('Time [s]')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 12 9]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');

print('sim_generate_speed_cart','-dpng','-r300');

%% Speed of the cart and angular of links
close
figure('Units','centimeters')
plot(t_span,[zhistory(:,2) zhistory(:,4) zhistory(:,6) zhistory(:,8)], 'LineWidth',2)
lgd1 = legend({'$\dot x_{cart}$' '$\dot\theta_1$' '$\dot\theta_2$' '$\dot\theta_3$'},'Interpreter','latex','FontSize', 14);

title('Speed of the cart and angular speed of links')
xlabel('Time [s]')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 11 9]);
set(gca, 'FontSize', 13, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('speed_angle_cart','-dpng','-r300');

%% Reversed input in the triple pendulum
close
figure('Units','centimeters')
plot(t_span, uinput_reversed(1,:), 'LineWidth', 2);
% legend('kinetic', 'potential', 'total');
xlabel('Time [s]');
ylabel('Force [N]');
title('Input of u for the cart')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 11 9]);
set(gca, 'FontSize', 14, 'LineWidth', 1, ...
    'XMinorTick','on', 'YMinorTick','on', ...
    'XGrid','on', 'YGrid','on', ...
    'FontName','Roboto Condensed', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('uinput_reversed','-dpng','-r300');

%% Error
close
figure('Units','centimeters')
error1 = (zhistory2(:,1)-zhistory1_reversed(:,1)).^2;
error2 = (zhistory2(:,3)-zhistory1_reversed(:,3)).^2;
error3 = (zhistory2(:,5)-zhistory1_reversed(:,5)).^2;
error4 = (zhistory2(:,7)-zhistory1_reversed(:,7)).^2;
plot(t_span,[error1 error2 error3 error4],'LineWidth',2)
title('Modified initial conditions with LQR')
ylabel('Deviation')
xlabel('Time [s]')
legend({'$x_{cart}$' '$\theta_1$' '$\theta_2$' '$\theta_3$'},'Interpreter','latex','FontSize', 12,'Location','northwest')
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2)-5 12 9]);
set(gca, 'FontSize', 11, 'LineWidth', 1, ...
    'XMinorTick','off', 'YMinorTick','off', ...
    'XGrid','on', 'YGrid','on', ...
    'TickLength',[0.02 0.02]);
set(gcf,'InvertHardcopy','on', 'PaperUnits','centimeters');
print('graph_error_mod_LQR','-dpng','-r300');

errortotal = sum(error1)+sum(error2)+sum(error3)+sum(error4)