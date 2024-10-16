function [res,t] = stepres(s,v_in,t_max,t_step,no_plot);
% Calculation of Step Response from state space object 
% 10:47 am 25 January 1998
% Syntax: [res, t] = stepres(s,v_in,t_max,t_step,noplot)
% Inputs: 
%         s  - state space object
%         v_in the magnitude of the input disturbance
%              a column vector of disturbance input measurements
%         t_max the maximum value of the response in sec
%         t_step integration time step s
%         noplot optional input if 1 there is no plot
% Outputs: res  - step response matrix
%           t   - time vector
% Use plot(t,res) to view the response
% Author: Graham Rogers
% Date:   August 1997
% (c) Copyright Joe Chow/Cherry Tree Scientific Software 1997
% All Rights Reserved

% check input compatibility
if ~isa(s,'stsp')
   uiwait(msgbox('s must be a state space object','stepres error','modal'))
   res =[];t=[];
   return
end
switch nargin
    case {1,2,3}
        uiwait(msgbox('four inputs are mandatory','stepres error','modal'))
        res =[];t=[];
        return
    case 4
        no_plot = 0;
end
if isempty(s.a)
   uiwait(msgbox('the state matrix is empty','stepres error','modal'))
   res =[];t=[];
   return
end
% check size of input disturbance
if length(v_in)~=s.NumInputs
   error('the input disturbance vector must be equal to the no. of inputs of s')
end


if t_step == 0
   num_steps = 500;
else
   num_steps = round(t_max/t_step);
end
t_step = t_max/num_steps;

% define time vector

t = 0:t_step:t_max;
x = zeros(s.NumStates,num_steps+1);
ahm = inv(eye(s.NumStates) - 0.5*t_step*s.a);
ahp = eye(s.NumStates) + 0.5*t_step*s.a;
ahmp = ahm*ahp;
ahmhh = t_step*ahm;
b = s.b*v_in;
res = zeros(s.NumOutputs,num_steps+1);
res(:,1) = s.d*v_in;
% trapezoidal integration
for k = 1:num_steps;x(:,k+1) = ahmp*x(:,k)+ ahmhh*b;end
res = real(s.c*x + s.d*v_in*ones(size(t)));
  
if ~no_plot;figure,plot(t,res);end
return