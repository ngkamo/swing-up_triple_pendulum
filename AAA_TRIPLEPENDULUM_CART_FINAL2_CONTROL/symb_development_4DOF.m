clear; close all; clc;

syms M m1 m2 m3;
syms x xd xdd theta1 theta1d theta1dd theta2 theta2d theta2dd theta3 theta3d theta3dd;
syms l1 l2 l3;
syms u1 u2 u3 u4;
syms g;

x1 = x + l1*sin(theta1);
y1 = -l1*cos(theta1);
x2 = x1 + l2*sin(theta2);
y2 = y1 - l2*cos(theta2);
x3 = x2 + l3*sin(theta3);
y3 = y2 - l3*cos(theta3);

x1d = xd + l1*cos(theta1)*theta1d;
y1d = l1*sin(theta1)*theta1d;
x2d = x1d + l2*cos(theta2)*theta2d;
y2d = y1d + l2*sin(theta2)*theta2d;
x3d = x2d + l3*cos(theta3)*theta3d;
y3d = y2d + l3*sin(theta3)*theta3d;

% Kinetic energy
KE = 0.5*M*xd^2 + 0.5*m1*(x1d^2+y1d^2) + 0.5*m2*(x2d^2+y2d^2) + 0.5*m3*(x3d^2+y3d^2);
KE = simplify(KE);

PE = m1*g*y1 + m2*g*y2 + m3*g*y3;
PE = simplify(PE);

Px1 = u1;
Px2 = u2;
Px3 = u3;
Px4 = u4;

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
	diff(KEtheta3d,theta3d)*theta3dd;;
KEtheta3 = diff(KE,theta3);
PEtheta3 = diff(PE,theta3);

eqx1 = simplify(dtKExd - KEx + PEx - Px1);
eqx2 = simplify(dtKEtheta1d - KEtheta1 + PEtheta1 - Px2);
eqx3 = simplify(dtKEtheta2d - KEtheta2 + PEtheta2 - Px3);
eqx4 = simplify(dtKEtheta3d - KEtheta3 + PEtheta3 - Px4);

Sol = solve(eqx1,eqx2,eqx3,eqx4,xdd,theta1dd,theta2dd,theta3dd)

syms y1 y2 y3 y4 y5 y6 y7 y8;
fx1 = subs(Sol.xdd, {x,xd,theta1,theta1d,theta2,theta2d,theta3,theta3d}, {y1,y2,y3,y4,y5,y6,y7,y8})
fx2 = subs(Sol.theta1dd, {x,xd,theta1,theta1d,theta2,theta2d,theta3,theta3d}, {y1,y2,y3,y4,y5,y6,y7,y8})
fx3 = subs(Sol.theta2dd, {x,xd,theta1,theta1d,theta2,theta2d,theta3,theta3d}, {y1,y2,y3,y4,y5,y6,y7,y8})
fx4 = subs(Sol.theta3dd, {x,xd,theta1,theta1d,theta2,theta2d,theta3,theta3d}, {y1,y2,y3,y4,y5,y6,y7,y8})