function [y,xn,dx] = dci_sud(i,k,flag,s,d_sig,ymax,ymin,x)
% Syntax: [y,xn,dx] = dci_sud(i,k,flag,s,d_sig,x)
% 9:21 am 10/6/99
%
% Purpose: inverter user defined damping control
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
% See Also: dc_cont,dcr_sud
% Algorithm:
%
% Calls:
%
% Called By:

% (c) Copyright Cherry Tree Scientific Software 1999 - All Rights Reserved

% History (in reverse chronological order)
% Author:   Graham Rogers
% Date:     June 1999

y=0;

NumStates = size(s.a,1);
NumInputs = size(s.b,2);
NumOutputs = size(s.c,1);

if flag == 0; % initialization
   if i ~= 0  % scalar computation
      % check user defined control
      if NumInputs~=1;error('ud inverter stabilizer must be single input');end
      if NumOutputs~=1;error('ud inverter stabilizer must be single output');end
      [y,xn] = seval(s,0,d_sig);
      if y>ymax;warning('y outside max limit initialy');y=ymax;end
      if y<ymin;warning('y outside minimum limit initially');y=ymin;end
      dx=zeros(size(xn));
   else
      error('no vector computation in user defined dc inverter stabilizer')
   end
end

if flag == 1 % network interface computation
   if i ~= 0 % scalar computation
      xmax = 1e5*ones(NumStates,1);xmin=-xmax;
      y = dstate(s,x,d_sig,xmax,xmin,ymax,ymin);
   else
      error('no vector computation for user defined inverter stabilizer')
   end
end

if flag == 2 % rectifier damping control dynamics calculation
   if i ~= 0 % scalar computation
      xmax = 1e5*ones(NumStates,1);xmin=-xmax;
      [y,xn,dx] = dstate(s,x,d_sig,xmax,xmin,ymax,ymin);
   else
      error('no vector computation for user defined inverter stabilizer')
   end
end
