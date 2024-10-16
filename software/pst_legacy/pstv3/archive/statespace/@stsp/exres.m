function [rs,ts,x_fin] = exres(s,vm,t_int,t_samp,t_noise,t_fin,x_start)
% Calculation of time response from state space object 
% 10:47 am 25 January 1998
% Syntax: [rs, ts] = exres(s,vm,t_int,t_samp,t_fin,x_start)
% Inputs: 
%         s    	-  state space object
%         vm		-  input magnitude;
%         t_int 	- time step used for integration
%         t_samp	- output sampled at t_samp 
%         t_noise - time step at which random input is changed
%         t_fin 	- finish time
%         x_start - state at time t  = 0;
%         if only 5 inputs x_start assumed to be zero
% Outputs: 
%			 rs  - time response matrix sampled at t_so=fix(t_fin/n_so)
%         ts  - time vector (output sampled at t_samp)
%         x_fin - state at t_fin
% 
% Assumes a random disturbance is applied to the input
% Note:
%      t_samp >=t_int
% Use plot(ts,rs) to view the response

% Author: Graham Rogers
% Date:   December 1999
% (c) Copyright Cherry Tree Scientific Software 1999
% All Rights Reserved

% check input compatibility
if ~isa(s,'stsp')
   error('s must be a state space object')
end
% find the eigenvalues of a
if isempty(s.a)
   error('the state matrix is empty')
end
tic
% use
nsteps = fix(t_fin/t_int);
nso = fix(t_samp/t_int);% number of internal time steps in sampled time step
nnoise = fix(t_noise/t_int);
ts = [0:nso:nsteps-1]*t_int;
x = zeros(s.NumStates,nsteps);
if nargin == 7
   x(:,1) = x_start;
end
vn = zeros(s.NumInputs,nsteps);
% integrate
ks = 0;
vn(:,1) = vm*randn(s.NumInputs,1);
ahm = inv(eye(s.NumStates) - 0.5*t_int.*s.a);
ahp = eye(s.NumStates) + 0.5*t_int*s.a;
ahmp = ahm*ahp;
ahmhh = t_int*ahm;

for k = 1:nsteps
	ks = ks+1;
	   if ks==nnoise;
      vn(:,k) = vm*randn(s.NumInputs,1);
      ks = 0;
   elseif k>1
      vn(:,k)=vn(:,k-1);
   end
	b = s.b*vn(:,k);
	x(:,k+1) = ahmp*x(:,k)+ ahmhh*b;
end 
rs = s.c*x(:,1:nso:nsteps) + s.d*vn(:,1:nso:nsteps);
x_fin = x(:,nsteps);
figure
plot(ts,rs)
toc
return
