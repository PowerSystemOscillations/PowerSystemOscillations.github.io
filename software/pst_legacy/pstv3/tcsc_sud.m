function [y,xn,dx] = tcsc_sud(i,k,flag,s,d_sig,ymax,ymin,x)
% Syntax: [y,xn,dx] = tcsc_sud(i,k,flag,s,d_sig,x)
% 11:38 am 29/12/98
%
% Purpose: tcsc user defined damping control
% Input: i - tcsc number
%        k - integer time
%        flag - 0 - initialization
%               1 - network interface computation
%               2 - system dynamics computation
%        s - control state space object
%        d_sig - damping control input
%        x - state
%
% Output:
%        y -  controller output
%        xn - state with limits applied
%        dx - rate of change of state
%
% Files:
%
% See Also: tcsc
% Algorithm:
%
% Calls:
%
% Called By:

% (c) Copyright Cherry Tree Scientific Software 1998 - All Rights Reserved

% History (in reverse chronological order)
% Author:   Graham Rogers
% Date:     December 1998

y=0;

NumStates = size(s.a,1);
NumInputs = size(s.b,2);
NumOutputs = size(s.c,1);

if flag == 0; % initialization
   if i ~= 0  % scalar computation
      % check user defined control
      if NumInputs~=1;error('ud tcsc stabilizer must be single input');end
      if NumOutputs~=1;error('ud tcsc stabilizer must be single output');end
      [y,xn] = eval(s,0,d_sig);
      if y>ymax;warning('y outside max limit initialy');y=ymax;end
      if y<ymin;warning('y outside minimum limit initially');y=ymin;end
      dx = zeros(size(xn));
   else
      error('no vector computation in user defined tcsc stabilizer')
   end
end

if flag == 1 % network interface computation
   %no interface computation in user defined tcsc stabilizer
end

if flag == 2 % tcsc damping control dynamics calculation
   if i ~= 0 % scalar computation
      xmax = 1e5*ones(NumStates,1);xmin=-xmax;
      [y,xn,dx] = dstate(s,x,d_sig,xmax,xmin,ymax,ymin);
   else
      error('no vector computation for user defined tcsc stabilizer')
   end
end
