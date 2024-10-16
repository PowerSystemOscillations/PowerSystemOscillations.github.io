function [r,t,xf,u] = randres(s,x0,ts,ns,dur)
% assumes that a random normal input disturbance is applied to all inputs of s
% x0 is the initial value of the states of s
% ts is the solution time step
% ns is the number of time steps at which the random input is changed
% dur is the total simulation time in seconds
% r is the ouput response
% t is the time vector
% xf is a vector of the final states of s
% u is the random input which changes every ns time steps
switch nargin
case 1
    x0 = zeros(s.NumStates,1);
    ts = .01;
    ns = 10;
    dur = 10;
case 2
    ts = .01;
    ns = 10;
    dur = 10;
case 3
    dur = 100*ts;
    ns = 10;
case 4
    dur = 100*ts;
end
% check length of x0
if size(x0,2)~=1&&~isempty(x0)
    error('x0 must be a vector')
elseif length(x0)~=s.NumStates
    error('the initial state vector must have a length equal to the number of states in s')
end
nsteps = fix(dur/ts);
nnsteps = nsteps/ns;
t = (0:nsteps-1)*ts;
f = randngen(s.NumInputs,nnsteps+1,'randn');
u = zeros(s.NumInputs,nsteps);
k = 1; kstart = ns+1;kfin = 2*ns;
while k<nnsteps 
    u(:,kstart:kfin) = repmat(f(:,k),1,ns);
    k=k+1; kstart = kfin+1;kfin = kfin+ns;
end
if ~isempty(s.a);
    [r,t,xf] = response(s,ones(s.NumInputs,1),t,x0,u);
elseif ~isempty(s.d)
    r = s.d*u; xf = 0;
end

