function [y,x,t] = nlsr(s,i_type,u,h,tmax,xmax,xmin,ymax,ymin)
% calculates response of a state space object to a step, impulse or ramp input
% syntax: [y,x,t] = nlsr(s,i_type,u,h,tmax,xmax,xmin,ymax,ymin)
% uses predictor-corrector integration
% each state may be non-windup limited (xmax and xmin)
% each output may be limited (ymax and ymin)
%input:
%      s - state space object
%      i_type  - 'st' - step response
%                'im; - impulse response
%                'ra' - ramp response
%      u - input vector
%      h - time step
%      tmax - maximum response time
%      xmax - vector of maximum state limits
%      xmin - vector of minimum state limits
%      ymax - vector of maximum output limits
%      ymin - vector of minimum output limits
%outputs:
%      y - output time response
%      x - state time response
%      t - time vector

% (c) copyright Cherry Tree Scientific Software 1998 - All rights reserved

if ~isa(s,'stsp')
   error('s must be a state space object')
elseif length(u)~=s.NumInputs
   error('The length of u must equal number of inputs of s')
end
if nargin < 5
   error('the first 5 input parameters must be specified')
elseif nargin==5
   % set limits to large positive and negative numbers
   xmax=1e5*ones(s.NumStates,1);xmin=-xmax;
   ymax=1e5*ones(s.NumOutputs,1);ymin=-ymax;
elseif nargin == 7
   if length(xmax)~=s.NumStates||length(xmin)~=s.NumStates
      error('xmax and xmin must have length equal to the number of states of s')
   else
      ymax=1e5*ones(s.NumOutputs,1);ymin=-ymax;
   end
elseif nargin == 9
   if length(ymax)~=s.NumOutputs||length(ymin)~=s.NumOutputs
      error('ymax and ymin must have length equal to number of outputs of s')
   end
end
nts = round(tmax/h)+1;
x = zeros(s.NumStates,nts);dx = x; y = zeros(s.NumOutputs,nts);t=(0:nts-1)*h;
if strcmp(i_type, 'st')
   ut = u*ones(1,nts);
elseif strcmp(i_type, 'im')
   ut = u*zeros(1,nts);
   ut(:,1)=u/2/h;ut(:,2)=ut(:,1);
elseif strcmp(i_type,'ra')
   ut = u*t;
else
   error('inputs are either step, impulse or ramp')
end
[y(:,1),x(:,1),dx(:,1)]= dstate(s,x(:,1),ut(:,1),xmax,xmin,ymax,ymin);
for k = 2:nts
   xp = x(:,k-1)+h*dx(:,k-1);
   [yp,xp,dxp]=dstate(s,xp,ut(:,k),xmax,xmin,ymax,ymin);
   xc = x(:,k-1) + (dxp + dx(:,k-1))*h/2;
   [y(:,k),x(:,k),dx(:,k)]=dstate(s,xc,ut(:,k),xmax,xmin,ymax,ymin);
end

