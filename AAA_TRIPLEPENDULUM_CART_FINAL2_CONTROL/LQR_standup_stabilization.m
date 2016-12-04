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
impulse(sys_ss,t)

t = 0:0.01:0.5;
r =1*ones(size(t));
[y,t,x]=lsim(sys_ss,r,t);
% plot(t,[y(:,1) y(:,2) y(:,3) y(:,4)]);

R = 1;

Q = diag([100 0 1000 0 1000 0 1000 0]);

[K,P,E] = lqr(A,B,Q,R);

Ac = A-B*K;
Bc = B;
Cc = C;
Dc = D;

sys_cl = ss(Ac,Bc,Cc,Dc);
t = 0:0.01:10;
r =[0 0*ones(1,100) 10*ones(1,900)];
[y,t,x]=lsim(sys_cl,r,t);
plot(t,[y(:,1) y(:,2) y(:,3) y(:,4)]);
legend('x_{cart}','\theta_1','\theta_2')
grid on