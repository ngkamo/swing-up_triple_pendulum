%--------------------------------------------------------------------------
% This file aims at animating the triple pendulum using inputs computed
% from the main_sim_three_dof_arm_cart_control_2.m
% Produces video file.
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%% POST PROCESSING %%%%%%%%%%%%%%%%%
close all;
% Animation of the simulation
load('setup.mat')
l1 = param.l1;
l2 = param.l2;
l3 = param.l3;
m1 = param.m1;
m2 = param.m2;
m3 = param.m3;
M  = param.M;
g  = param.g;

zhistory_res = zhistory2;
% Setting up the recording of the animation
writerObj = VideoWriter('out_sim_bad_swingup'); % Name of the output
writerObj.Quality = 100;
writerObj.FrameRate = 50; % Frames per second
open(writerObj);

%%%%%%%%%%%%%%%%%%%% ANIMATION %%%%%%%%%%%%%%%%%%%%%
figure('Units','centimeters');
pos = get(gcf, 'Position');
hold on;
for i=1:size(zhistory_res,1)-1
    if(mod(i,2)==1)
        clf;
        p0x = zhistory_res(i,1);
        p0y = 0;
        x1  = zhistory_res(i,1) - l1*sin(zhistory_res(i,3));
        y1  = l1*cos(zhistory_res(i,3));
        x2  = x1 - l2*sin(zhistory_res(i,5));
        y2  = y1 + l2*cos(zhistory_res(i,5));
        x3  = x2 - l3*sin(zhistory_res(i,7));
        y3  = y2 + l3*cos(zhistory_res(i,7));
        hold on

        plot(p0x,0,'k.','MarkerSize',40);  % pivot point
        plot([p0x x1],[0 y1], 'Color',[0.4353 0.9765 0.1882], 'LineWidth',6);  % 1st link
        plot([x1 x2],[y1 y2], 'Color',[0.9294 0.0509 0.0274], 'LineWidth',6);  % 2nd link
        plot([x2 x3],[y2 y3], 'Color',[0.1411 0.5921 1], 'LineWidth',6);       % 3rd link

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
        pause(0.001);
        frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
        writeVideo(writerObj, frame);
    end
end

close(writerObj); % Saves the movie.
