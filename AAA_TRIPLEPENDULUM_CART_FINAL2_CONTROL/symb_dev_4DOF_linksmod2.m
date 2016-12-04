% Angles down zero
clear; clc

syms M m1 m2 m3;
syms x xd xdd theta1 theta1d theta1dd theta2 theta2d theta2dd theta3 theta3d theta3dd;
syms l1 l2 l3;
syms u1;
syms g;

% x1 = x + l1/2*sin(theta1);
% y1 = -l1/2*cos(theta1);
% x2 = x + l1*sin(theta1) + l2/2*sin(theta2);
% y2 = -l1*cos(theta1) - l2/2*cos(theta2);
% x3 = x + l1*sin(theta1) + l2*sin(theta2) + l3/2*sin(theta3);
% y3 = -l1*cos(theta1) - l2*cos(theta2) - l3/2*cos(theta3);

%%%%%%%%%%%%%%%%%%% POSITION OF CENTER OF MASS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
p1 = [x+l1/2*sin(theta1); -l1/2*cos(theta1)];
p2 = [x + l1*sin(theta1) + l2/2*sin(theta2); -l1*cos(theta1) - l2/2*cos(theta2)];
p3 = [x + l1*sin(theta1) + l2*sin(theta2) + l3/2*sin(theta3); -l1*cos(theta1) - l2*cos(theta2) - l3/2*cos(theta3)];

%%%%%%%%%%%%%%%%%%%%% SPEED OF CENTER OF MASS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p1d = diff(p1,x)*xd + diff(p1,theta1)*theta1d;
p2d = diff(p2,x)*xd + diff(p2,theta1)*theta1d + diff(p2,theta2)*theta2d;
p3d = diff(p3,x)*xd + diff(p3,theta1)*theta1d + diff(p3,theta2)*theta2d + diff(p3,theta3)*theta3d;

%%%%%%%%%%%%%%%%%% LAGRANGIAN OF THE TRIPLE PENDULUM %%%%%%%%%%%%%%%%%%%%%%
% Kinetic energy
KE = 0.5 * (M*xd^2 + m1*(p1d.')*p1d + m2*(p2d.')*p2d + m3*(p3d.')*p3d) + ...
    0.5 * (m1*l1^2/12*theta1d^2 + m2*l2^2/12*theta2d^2 + m3*l3^2/12*theta3d^2);
KE = simplify(KE);

% Potential energy
PE = g * (m1*p1(2) + m2*p2(2) + m3*p3(2));

% Lagrangian derivation
KExd = diff(KE,xd);
dtKExd = diff(KExd,xd)*xdd + ...
	diff(KExd,theta1)*theta1d + ...
	diff(KExd,theta1d)*theta1dd + ...
	diff(KExd,theta2)*theta2d + ...
	diff(KExd,theta2d)*theta2dd + ...
	diff(KExd,theta3)*theta3d + ...
	diff(KExd,theta3d)*theta3dd;
KEx = diff(KE,x);
PEx = diff(PE,x);

KEtheta1d = diff(KE,theta1d);
dtKEtheta1d = diff(KEtheta1d,theta1)*theta1d + ...
	diff(KEtheta1d,theta1d)*theta1dd + ...
	diff(KEtheta1d,xd)*xdd + ...
	diff(KEtheta1d,theta2)*theta2d + ...
	diff(KEtheta1d,theta2d)*theta2dd + ...
	diff(KEtheta1d,theta3)*theta3d + ...
	diff(KEtheta1d,theta3d)*theta3dd;
KEtheta1 = diff(KE,theta1);
PEtheta1 = diff(PE,theta1);

KEtheta2d = diff(KE,theta2d);
dtKEtheta2d = diff(KEtheta2d,theta1)*theta1d + ...
	diff(KEtheta2d,theta1d)*theta1dd + ...
	diff(KEtheta2d,xd)*xdd + ...
	diff(KEtheta2d,theta2)*theta2d + ...
	diff(KEtheta2d,theta2d)*theta2dd + ...
	diff(KEtheta2d,theta3)*theta3d + ...
	diff(KEtheta2d,theta3d)*theta3dd;;
KEtheta2 = diff(KE,theta2);
PEtheta2 = diff(PE,theta2);

KEtheta3d = diff(KE,theta3d);
dtKEtheta3d = diff(KEtheta3d,theta1)*theta1d + ...
	diff(KEtheta3d,theta1d)*theta1dd + ...
	diff(KEtheta3d,xd)*xdd + ...
	diff(KEtheta3d,theta2)*theta2d + ...
	diff(KEtheta3d,theta2d)*theta2dd + ...
	diff(KEtheta3d,theta3)*theta3d + ...
	diff(KEtheta3d,theta3d)*theta3dd;
KEtheta3 = diff(KE,theta3);
PEtheta3 = diff(PE,theta3);

%%%%%%%%%%%%%%%%%%%%%%%% EQUATIONS OF MOTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eqx1 = simplify(dtKExd - KEx + PEx - u1);
eqx2 = simplify(dtKEtheta1d - KEtheta1 + PEtheta1);
eqx3 = simplify(dtKEtheta2d - KEtheta2 + PEtheta2);
eqx4 = simplify(dtKEtheta3d - KEtheta3 + PEtheta3);

Sol = solve(eqx1,eqx2,eqx3,eqx4,xdd,theta1dd,theta2dd,theta3dd)

syms z1 z2 z3 z4 z5 z6 z7 z8;
fx1 = subs(Sol.xdd, {x,xd,theta1,theta1d,theta2,theta2d,theta3,theta3d}, {z1,z2,z3,z4,z5,z6,z7,z8});
fx2 = subs(Sol.theta1dd, {x,xd,theta1,theta1d,theta2,theta2d,theta3,theta3d}, {z1,z2,z3,z4,z5,z6,z7,z8});
fx3 = subs(Sol.theta2dd, {x,xd,theta1,theta1d,theta2,theta2d,theta3,theta3d}, {z1,z2,z3,z4,z5,z6,z7,z8});
fx4 = subs(Sol.theta3dd, {x,xd,theta1,theta1d,theta2,theta2d,theta3,theta3d}, {z1,z2,z3,z4,z5,z6,z7,z8});

fx1 = simplify(fx1);
fx2 = simplify(fx2);
fx3 = simplify(fx3);
fx4 = simplify(fx4);

fx = [fx1 fx2 fx3 fx4];

%%
feq1 = xd;
feq2 = eqx1;
feq3 = theta1d;
feq4 = eqx2;
feq5 = theta2d;
feq6 = eqx3;
feq7 = theta3d;
feq8 = eqx4;

A = jacobian([feq1; feq2; feq3; feq4; feq5; feq6; feq7; feq8], [x xd theta1 theta1d theta2 theta2d theta3 theta3d]);
