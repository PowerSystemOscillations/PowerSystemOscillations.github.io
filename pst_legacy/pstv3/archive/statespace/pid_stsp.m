function spid = pid_stsp(kp,ki,kd,Td)
% spid = kp + ki/s + kd s/(1+sTd)
% syntax: spid = pid_stsp(kp,ki,kd,Td)
% forms a state space object for a proportional + integral + derivative controller
%inputs:
%       kp - proportional gain
%       ki - integral gain
%       kd - derivative gain
%       Td - derivative time constant
%output: state space object

% author: Graham Rogers
% date: September 1998
% (c) copyright Cherry Tree Scientific Software 1998
% All rights reserved
n_p = length(kp);n_i = length(ki);n_d = length(kd);n_Td = length(Td);
if n_i~=n_p||n_i~=n_p||n_Td~=n_p
   error('kp,ki,kd and Td must be scalars or vectors of the same length')
end
ki_idx = find(ki~=0);
if ~isempty(ki_idx);
   n_ki = length(ki_idx);
   a_i = zeros(n_ki);
   b_i = zeros(n_ki,n_i);
   b_i(:,ki_idx) = eye(n_ki);
   c_i = zeros(n_i,n_ki);
   c_i(ki_idx,:)=diag(ki(ki_idx));
   d_i = zeros(n_i);
   si = stsp(a_i,b_i,c_i,d_i);
else
   si = stsp([],[],[],zeros(n_i));
end
kp_idx = find(kp~=0);
if ~isempty(kp_idx);
   sp = stsp([],[],[],diag(kp));
else
   sp = stsp([],[],[],zeros(n_p));
end
kd_idx = find(kd~=0&Td~=0);
if ~isempty(kd_idx)
   n_kd = length(kd_idx);
   a = diag(-1./Td(kd_idx));
   b = zeros(n_kd,n_d);
   b(:,kd_idx)=diag(1./Td(kd_idx));
   c = zeros(n_d,n_kd);
   c(kd_idx,:) = a*diag(kd(kd_idx));
   d = zeros(n_d);
   d(kd_idx,kd_idx) = -a*diag(kd(kd_idx));
   sd = stsp(a,b,c,d);
else
   sd = stsp([],[],[],zeros(n_d));
end
spid =  parallel(sp,si,sd);