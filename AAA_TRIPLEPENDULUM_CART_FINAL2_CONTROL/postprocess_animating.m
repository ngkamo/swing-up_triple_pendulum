%--------------------------------------------------------------------------
% This file aims at animating the triple pendulum using inputs computed
% from the main_sim_three_dof_arm_cart_control_2.m
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%% POST PROCESSING %%%%%%%%%%%%%%%%%
close all;
% Animation of the simulation
zhistory = zhistory1;
animate = false;       % Change value here if you want to see the animation
% record = true;        % Change value here if you want to record
if animate
    % Setting up the video
%     writerObj = VideoWriter('out3_initchanged'); % Name of the output
%     writerObj.Quality = 100;
%     writerObj.FrameRate = 50; % Frames per second
%     open(writerObj);

    % Print initial position in grey
    p0x0 = zhistory1(1,1);
    p0y0 = 0;
    x10  = zhistory1(1,1) + l1*sin(zhistory1(1,3));
    y10  = -l1*cos(zhistory1(1,3));
    x20  = x10 + l2*sin(zhistory1(1,5));
    y20  = y10 - l2*cos(zhistory1(1,5));
    x30  = x20 + l3*sin(zhistory1(1,7));
    y30  = y20 - l3*cos(zhistory1(1,7));

    figure('Units','centimeters');
    pos = get(gcf, 'Position');
    hold on;
    for i=1:N
        if(mod(i,5)==0)
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
            plot(p0x0,0,'.' ,'Color',[0.7843 0.7843 0.7843] ,'MarkerSize',40);                % pivot point
            plot([p0x0 x10 x20 x30],[0 y10 y20 y30], 'Color',[0.7843 0.7843 0.7843], 'LineWidth',4);        % 1st link

            plot(p0x,0,'k.','MarkerSize',40);                % pivot point
            plot([p0x x1],[0 y1], 'Color',[0.4353 0.9765 0.1882], 'LineWidth',6);        % 1st link
            plot([x1 x2],[y1 y2], 'Color',[0.9294 0.0509 0.0274], 'LineWidth',6);        % 2nd link
            plot([x2 x3],[y2 y3], 'Color',[0.1411 0.5921 1], 'LineWidth',6);        % 3rd link

            time = annotation('textbox',...
                'LineStyle','none',...
                'String',{['time [s]: ',num2str(t_span(i),'%.2f')],...
                ['initial conditions: xcart=',num2str(x0(1))],...
                ['theta1=',num2str(x0(3)),' theta2=',num2str(x0(5)),' theta3=',num2str(x0(7))],...
                ['dtheta1=',num2str(x0(4)),' dtheta2=',num2str(x0(6)),' dtheta3=',num2str(x0(8))]} );
            set(time, 'FontName','Roboto Condensed', 'FontSize', 13, ...
                'Units','centimeters', 'Position',[3 3 11 2]);
            set(gcf, 'Position', [pos(1) pos(2)-5 17 17]);
            set(gca, 'LineWidth', 1, 'FontSize', 15, 'FontName','Roboto Condensed');
            axis([-4 4 -4 4]);
            xlabel('x [m]');
            ylabel('y [m]');
            axis square
            set(gca, 'FontName','Roboto Condensed');
            grid on
            pause(0.01);
%             frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
%             writeVideo(writerObj, frame);
        end
    end

%     close(writerObj); % Saves the movie.
end


%
% % Plotting all the results on graphs
% dimsubx = 2;
% dimsuby = 3;
%
% figure(2)
% grid on
% subplot(dimsuby,dimsubx,1)
% plot(t_span,[zhistory(:,1) zhistory(:,3) zhistory(:,5) zhistory(:,7)])
% lgd1 = legend('$x_{cart}$','$\theta_1$','$\theta_2$','$\theta_3$')
% set(lgd1,'Interpreter','latex','FontSize',12);
% title('Positions of the cart and angles of  links')
% xlabel('Time [s]')
% grid on
%
% subplot(dimsuby,dimsubx,2)
% plot(t_span,[zhistory(:,2) zhistory(:,4) zhistory(:,6) zhistory(:,8)])
% lgd2 = legend('$\dot{x}_{cart}$','$\dot{\theta}_1$','$\dot{\theta}_2$','$\dot{\theta}_3$')
% set(lgd2,'Interpreter','latex','FontSize',12);
% title('Speed and angular speeds')
% xlabel('Time [s]')
% grid on
%
% subplot(dimsuby,dimsubx,3)
% [PE, KE] = postprocess_energy(zhistory,l1,l2,l3,m1,m2,m3,M,g)
% % Total energy
% PE = 68.6 + PE;
% TE = KE + PE;
% TE_diff = diff(TE);
% plot(t_span, [KE, PE, KE+PE])
% legend('KE','PE','KE+PE')
% title('Potential and kinetic energy')
% xlabel('Time [s]')
% grid on
%
% subplot(dimsuby,dimsubx,4)
% plot(t_span(1:end-1),TE_diff)
% title('Variation of the total energy')
% xlabel('Time [s]')
% grid on
%
% subplot(dimsuby,dimsubx,[5 6])
% plot(t_span, uhistory(1,:))
% title('Force input on the cart')
% xlabel('Time [s]')
% grid on
%

uinput_reversed = [];
for i = 1:size(uhistory,2)
    uinput_reversed(i) = uhistory(1,end-i+1);
end
save('uinput_reversed.mat','uinput_reversed');
save('initial_cond_reversed.mat','zhistory');

%
% figure(3)
% plot(t_span, uinput_reversed)
% title('Input of the cart reversed')
% xlabel('Time [s]')
% grid on
%
