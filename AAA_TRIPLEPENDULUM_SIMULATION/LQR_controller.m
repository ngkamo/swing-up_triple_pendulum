%--------------------------------------------------------------------------
% Linearize around a given position
% Check the controlability of the system around the linearized position
% Return the matrix K
%--------------------------------------------------------------------------

function K=LQR_controller(z,u)
  %%%%%%%% LINEARIZATION OF THE SYSTEM %%%%%%%%
  % Loading state-space model and parameters
  load('setup.mat')
  load('state_space_symb.mat')
  l1 = param.l1;  l2 = param.l2;  l3 = param.l3;  % length of the links
  m1 = param.m1;  m2 = param.m2;  m3 = param.m3;  % masses at the end of each link
  M  = param.M;                          % mass of the cart
  g  = param.g;
  u1 = u;

  % Linearizing around the following configuration
  z1 = z(1); z2 = z(2);
  z3 = z(3); z4 = z(4);
  z5 = z(5); z6 = z(6);
  z7 = z(7); z8 = z(8);

  A_lin = eval(A);
  B_lin = eval(B);

  C = zeros(4,8);
  C(1,1) = 1;
  C(2,3) = 1;
  C(3,5) = 1;
  C(4,7) = 1;

  D = zeros(4,1);

  %%%%%%%%%%%%%%% CONTROLABILITY OF THE LINEARIZED SYSTEM %%%%%%%%%%%%%%%
  Co = ctrb(A_lin,B_lin);
  r_Co = rank(Co);

  if r_Co == 8
    fprintf('The system is controllable. Rank of Co: %d \n',r_Co);
  else
    fprintf('The system is not controllable. Rank of Co: %d \n',r_Co);
  end

  %%%%%%%%%%%%%%%%%% LQR CONTROLLER %%%%%%%%%%%%%%%%%%
  R = 1;
  Q = C'*C;
  Q = diag([100 0 1000 0 1000 0 1000 0]);

  [K,P,E] = lqr(A_lin,B_lin,Q,R);
end
