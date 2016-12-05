close all; clear; clc

A = [0   1      0    0      0    0    0     0;
     0   0   33.6    0   -6.0    0    0.6   0;
     0   0      0    1      0    0    0     0;
     0   0   96.6    0  -54.0    0    5.4   0;
     0   0      0    0      0    1    0     0;
     0   0  -75.6    0   87.0    0  -23.4   0;
     0   0      0    0      0    0    0     1;
     0   0   18.9    0  -58.5    0   42.6   0];

 B = [0;
      0.7755;
      0;
      0.9796;
      0;
     -0.2449;
      0;
      0.0612];

C = zeros(4,8);
C(1,1) = 1;
C(2,3) = 1;
C(3,5) = 1;
C(4,7) = 1;

D = zeros(4,1);

sys_ss = ss(A,B,C,D);

% t = 0:0.01:0.5;
% r =1*ones(size(t));
% [y,t,x]=lsim(sys_ss,r,t);
% plot(t,[y(:,1) y(:,2) y(:,3) y(:,4)]);

R = 1;

Q = diag([100 0 1000 0 1000 0 1000 0]);

[K,P,E] = lqr(A,B,Q,R);

Ac = A-B*K;
Bc = B;
Cc = C;
Dc = D;

% sys_cl = ss(Ac,Bc,Cc,Dc);
% t = 0:0.001:10;
% r =[0 0*ones(1,100) 50*ones(1,900)];
% [y,t,x]=lsim(sys_cl,r,t);

% legend('x_{cart}','\theta_1','\theta_2')
% grid on

%% Adding precompensation
Cn = [1 0 0 0 0 0 0 0];
sys_ss = ss(A,B,Cn,0);
Nbar = rscale(sys_ss,K)

sys_cl = ss(Ac,Bc*Nbar,Cc,Dc);
y = [0 0 0.1 0 -0.1 0 0 -0.3];
t = 0:0.001:5;
r =2*ones(size(t));
[y,t,x]=lsim(sys_cl,r,t,y);
figure(3);
plot(t,[y(:,1) y(:,2) y(:,3) y(:,4)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%% ANIMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l1 = 1; l2 = 1; l3 = 1;
figure('Units','centimeters');
pos = get(gcf, 'Position');
for i=1:size(t,1)
    if(mod(i,50)==0)
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
            ['theta1=',num2str(y(1,2),'%.2f'),' theta2=',num2str(y(1,3),'%.2f'),' theta3=',num2str(y(1,4),'%.2f')]} );
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
%%
figure(4)
p0x = y(1,1);
p0y = 0;
x1  = y(1,1) - l1*sin(y(1,2));
y1  = l1*cos(y(1,2));
x2  = x1 - l2*sin(y(1,3));
y2  = y1 + l2*cos(y(1,3));
x3  = x2 - l3*sin(y(1,4));
y3  = y2 + l3*cos(y(1,4));
hold on
plot(p0x,0,'k.','MarkerSize',40);                % pivot point
plot([p0x x1],[0 y1], 'Color',[0.4353 0.9765 0.1882], 'LineWidth',6);        % 1st link
plot([x1 x2],[y1 y2], 'Color',[0.9294 0.0509 0.0274], 'LineWidth',6);        % 2nd link
axis([-4 4 -4 4]);
grid on
axis square
plot([x2 x3],[y2 y3], 'Color',[0.1411 0.5921 1], 'LineWidth',6);        % 3rd link