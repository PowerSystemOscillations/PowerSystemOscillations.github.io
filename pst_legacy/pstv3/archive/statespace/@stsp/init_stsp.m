function [x,u] = init_stsp(s,y)
%finds the initial input vector and the initial states to satisfy an initial output y
%syntax: [x,u]=init_stsp(s,y)
%input:
%      s - state space object
%      y - initial output vector
%outputs:
%      x - initial state vector
%      u - initial input vector
%author: Graham Rogers
%date: November 1998

% check size of y
if length(y)~=s.NumOutputs
   error('dimension of y inconsistent with s')
end
a = [s.a s.b;s.c s.d];
ya = [zeros(s.NumStates,1);y];
xa = a\ya;
x = xa(1:s.NumStates);
u= xa(s.NumStates+1:length(xa));

