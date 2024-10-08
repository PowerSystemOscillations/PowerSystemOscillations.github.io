function [res,t,x] = response(s,v_in,t,x0,f_in)
% Calculation of time response from state space object 
% 9:17 am 29 June 2001
% Syntax: [res, t] = response(s,v_in,t,x0)
% Inputs: 
%         s    -  state space object
%         v_in -  a column vector, of length equal to the number of inputs to s,
%                 defining the proportion of the input fed to each input of s
%         t    -  a row vector of time  
%         x0   -  initial value of x - zero if not specified
%         f_in -  if f_in is a row vector of size t, 
%                 the inputs are obtained by
%                 v_in*f_in
%                 if f_in is a matrix with the number of rows equal to the number of inputs
%                 and the number of columns equal to the length of t, the inputs are obtained by
%                 u(t) = diag(v_in)*f_in
% Outputs: res  - time response matrix
%          t    - time
%          x    - state vector at t = max(t)
%  
% Use plot(t,res) to view the response
% Author: Graham Rogers
% Modified: June 2001
% Date:   November 1998
% (c) Copyright Cherry Tree Scientific Software 1998
% All Rights Reserved

% check input compatibility
if ~isa(s,'stsp')
   error('s must be a state space object')
end
if nargin<3; error('s,v_in and t must be entered');end
ntsteps = length(t)-1;
x = zeros(s.NumStates,1);
res = zeros(s.NumOutputs,length(t));
if nargin==4; x=x0;f_in = ones(1,length(t));end
if nargin==5;x=x0;end
res(:,1)=s.c*x;
% check size of input disturbance
[nrows,ncols]=size(v_in);
if nrows~=s.NumInputs
   error('the input disturbance vector rows must be equal to the no. of inputs of s')
end
[nrf,ncf]=size(f_in);
if ncf~=length(t)
   error('the number of columns of f_in must equal the length of t')
end
if nrf == 1
    b = s.b*v_in*f_in;
elseif nrf~=s.NumInputs
    error(' the number of rows of f_in must be either 1 or equal to the number of inputs of s')
else
    b = s.b*diag(v_in)*f_in;
end

t_step = diff(t);dts = diff(t_step);sdts = sum(dts);
% trapezoidal integration
if sdts==0
    ahm = eye(s.NumStates) - 0.5*t_step(1).*s.a;
    ahp = eye(s.NumStates) + 0.5*t_step(1)*s.a;
end
for k = 1:ntsteps
    if sdts~=0
        ahm = eye(s.NumStates) - 0.5*t_step(k).*s.a;
        ahp = eye(s.NumStates) + 0.5*t_step(k)*s.a;
    end
    ahmhh = 0.5*t_step(k)*(b(:,k)+b(:,k+1));
    x = ahm\(ahp*x+ ahmhh);
    res(:,k+1) = s.c*x;
end 
if nrf == 1
    res = res + s.d*v_in*f_in;
else
    res = res +s.d*diag(v_in)*f_in;
end
return