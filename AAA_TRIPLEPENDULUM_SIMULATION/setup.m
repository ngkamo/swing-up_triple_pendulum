%--------------------------------------------------------------------------
% Setup files containing the parameters for numerical simulation
% Execute code when changing parameters
%--------------------------------------------------------------------------

param = struct('l1',1,'l2',1,'l3',1, ...  % length of the links
        'm1',1,'m2',1,'m3',1,'M',1,....   % masses
        'g',9.8);

save('setup.mat','param');