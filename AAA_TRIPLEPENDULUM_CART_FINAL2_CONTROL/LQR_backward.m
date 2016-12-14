%--------------------------------------------------------------------------
% Triple pendulum project: Swinging up part
% Updates:
%   - Retrieve the data of positions and speeds, also the input to the cart
%--------------------------------------------------------------------------
%%% Main file %%%

close all; clc;

%%%%%%%%% DEFINITIONS OF THE PARAMETERS %%%%%%%%%
l1 = 1;     l2 = 1;     l3 = 1;  % length of the links
m1 = 1;     m2 = 1;     m3 = 2;  % masses at the end of each link
M  = 1;                          % mass of the cart
g  = 9.8;
k1 = 0.5;   k2 = 4;              % constants for the PD controller
u = [0 0 0 0]';

load('uinput_reversed')
load('initial_cond_reversed')


%%%%% SETTING PARAMETERS FOR THE ODE SOLVER %%%%%
init_t = 0;
final_t = 15;
dt = 0.001;
N = (final_t-init_t)/dt;
t_span = [init_t:dt:final_t-dt];

%%%%%%%%%%%%% INITIAL CONDITIONS %%%%%%%%%%%%%%%%
x0 = zhistory(end,:) + [0 0 0 0 0 0 0 0];
x0(2) = -x0(2);
x0(4) = -x0(4);
x0(6) = -x0(6);
x0(8) = -x0(8);
x0 = x0';
zhistory2 = [];
uhistory = [];

%%%%%%%%%%%%%%%%%% ODE SOLVER %%%%%%%%%%%%%%%%%%%
options = odeset('abstol',1e-9,'reltol',1e-9);
[t,z] = ode113(@three_dof_arm_cart_dyn_for_ODE, t_span, x0, options,u,l1,l2,l3,m1,m2,m3,M,g);

xprec = x0;
for i =1:N
    [t1,z1] = ode113(@three_dof_arm_cart_dyn_for_ODE, [0 dt 0.05], xprec,options,u,l1,l2,l3,m1,m2,m3,M,g);
    zhistory2 = [zhistory2; z1(2,:)];
    u = [uinput_reversed(i) 0 0 0]';
    xprec = z1(2,:);
end

zhistory2 = [x0'; zhistory2];
zhistory2(end,:) = [ ];

%%%%%%%%%%%%%%% POST PROCESSING %%%%%%%%%%%%%%%%%
% Animation of the simulation
figure; 
hold on;
for i=1:N
    if(mod(i,5)==0)
        clf;
        p0x = zhistory2(i,1);
        p0y = 0;
        x1  = zhistory2(i,1) + l1*sin(zhistory2(i,3));
        y1  = -l1*cos(zhistory2(i,3));
        x2  = x1 + l2*sin(zhistory2(i,5));
        y2  = y1 - l2*cos(zhistory2(i,5));
        x3  = x2 + l3*sin(zhistory2(i,7));
        y3  = y2 - l3*cos(zhistory2(i,7));
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
% 
% % Plotting all the results on graphs
% figure(2)
% plot(t_span,zhistory2(:,1))
% 
% [PE, KE] = postprocess_energy(zhistory2,l1,l2,l3,m1,m2,m3,M,g);
% % Total energy
% figure(3)
% PE = 88.2 + PE;
% plot(t_span, [KE, PE, KE+PE])
% legend('KE','PE','KE+PE')
% TE = KE + PE;
% TE_diff = diff(TE);
% figure(4)
% plot(t_span(1:end-1),TE_diff)
% grid on
% title('Variation of the total energy')
