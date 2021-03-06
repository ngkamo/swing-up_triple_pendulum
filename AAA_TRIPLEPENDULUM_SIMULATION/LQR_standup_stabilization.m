%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example of a stabilization of the triple
% pendulum with designed LQR controller
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc

load('state_space_symb.mat');

l1 = 1;     l2 = 1;     l3 = 1;  % length of the links
m1 = 1;     m2 = 1;     m3 = 1;  % masses at the end of each link
M  = 1;                          % mass of the cart
g  = 9.8;
u1 = 0;
z1 = 0; z2 = 0;
z3 = 0; z4 = 0;
z5 = 0; z6 = 0;
z7 = 0; z8 = 0;

A_lin = eval(A);
B_lin = eval(B);

C = zeros(4,8);
C(1,1) = 1;
C(2,3) = 1;
C(3,5) = 1;
C(4,7) = 1;

D = zeros(4,1);

R = 2;
Q = C'*C;
Q = diag([100 0 100 0 100 0 100 0]);


[K,P,E] = lqr(A_lin,B_lin,Q,R);
save('LQR_K.mat','K')

Ac = A_lin-B_lin*K;
Bc = B_lin;
Cc = C;
Dc = D;

sys_cl = ss(Ac,Bc,Cc,Dc);
y = [0 0 -0.1 0 -0.1 0 -0.1 0];
t = 0:0.001:5;
r =0*ones(size(t));
[y,t,x]=lsim(sys_cl,r,t,y);

%%%%%%%%%%%%%%%%%%%%%%%%%%% ANIMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l1 = 1; l2 = 1; l3 = 1;
figure('Units','centimeters');
pos = get(gcf, 'Position');
for i=1:size(t,1)
    if(mod(i,50)==1)
        clf;
        p0x = y(i,1);
        p0y = 0;
        x1  = y(i,1) - l1*sin(y(i,2));
        y1  = l1*cos(y(i,2));
        x2  = x1 - l2*sin(y(i,3));
        y2  = y1 + l2*cos(y(i,3));
        x3  = x2 - l3*sin(y(i,4));
        y3  = y2 + l3*cos(y(i,4));

        hold on
        plot(p0x,0,'k.','MarkerSize',40);                % pivot point
        plot([p0x x1],[0 y1], 'Color',[0.4353 0.9765 0.1882], 'LineWidth',6);        % 1st link
        plot([x1 x2],[y1 y2], 'Color',[0.9294 0.0509 0.0274], 'LineWidth',6);        % 2nd link
        plot([x2 x3],[y2 y3], 'Color',[0.1411 0.5921 1], 'LineWidth',6);        % 3rd link

        time = annotation('textbox',...
            'LineStyle','none',...
            'String',{['time [s]: ',num2str(t(i),'%.2f')],...
            ['initial conditions: xcart=',num2str(y(1,1),'%.2f')],...
            ['theta1=',num2str(y(1,2),'%.2f'),'  theta2=',num2str(y(1,3),'%.2f'),'  theta3=',num2str(y(1,4),'%.2f')]} );
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
    end
end
