function [y,xn,dx] = hvdc_sud(i,k,flag,s,d_sig,ymax,ymin,x)
% Syntax: [f] = hvdc_sud(i,k,flag,s,d_sig,x)
% 4:02 pm - January 15, 1999
% Purpose: HVDC user defined damping control
% Input: i - converter number
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
% See Also:
% Algorithm:
%
% Calls:
%
% Called By:

% (c) Copyright Cherry Tree Scientific Software 1998 - All Rights Reserved

% History (in reverse chronological order)
% Author:   Graham Rogers
% Date:     January 1999

y=0;

NumStates = size(s.a,1);
NumInputs = size(s.b,2);
NumOutputs = size(s.c,1);

if flag == 0; % initialization
   if i ~= 0  % scalar computation
      % check user defined control
      if NumInputs~=1;error('ud svc stabilizer must be single input');end
      if NumOutputs~=1;error('ud svc stabilizer must be single output');end
      [y,xn] = seval(s,0,d_sig);
      if y>ymax;warning('y outside max limit initialy');y=ymax;end
      if y<ymin;warning('y outside minimum limit initially');y=ymin;end
      dx=zeros(size(xn));
   else
      error('no vector computation in user defined hvdc stabilizer')
   end
end

if flag == 1 % network interface computation
   %no interface computation in user defined svc stabilizer???
end

if flag == 2 % hvdc damping control dynamics calculation
   if i ~= 0 % scalar computation
      xmax = 1e5;xmin = -xmax;
      [y,xn,dx] = dstate(s,x,d_sig,xmax,xmin,ymax,ymin);
   else
      error('no vector computation for user defined hvdc stabilizer')
   end
end
