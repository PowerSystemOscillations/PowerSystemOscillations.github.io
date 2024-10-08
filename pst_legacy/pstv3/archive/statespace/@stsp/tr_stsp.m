function [res] = tr_stsp(s,v_in,t,x0)
% Calculation of time response from state space object 
%
% Syntax: [res] = tr_stsp(s,v_in,t,x0)
% Inputs: 
%         s    -  state space object; single input, may be multiple outputs
%         v_in -  the input matrix, the kth column is the value of the input
%                 at t(k)
%         t    -  a row vector of time corresponding to the input 
%         x0   -  initial value of x - zero if not specified
% Outputs: res  - time response matrix
%  
% Use plot(t,res) to view the response
% Author: Graham Rogers
% Modified: June 2001 Corrected calculation, input incorrect - reported by Laiq Khan
% Date:   November 1998
% (c) Copyright Cherry Tree Scientific Software 1998
% All Rights Reserved

% check input compatibility
if ~isa(s,'stsp')
   error('s must be a state space object')
end
% find the eigenvalues of a
if isempty(s.a)
   error('the state matrix is empty')
end
% check size of input disturbance
[nrows,ncols]=size(v_in);
if s.NumInputs~=1
    error('tr_stsp is valid only for single input systems')
end
if ncols~=length(t)
   error('the number of columns of the input matrix must equal the length of t')
end
ntsteps = length(t)-1;
x = zeros(s.NumStates,length(t));
if nargin==4; x(:,1)=x0;end
tm = zeros(size(t));tm(1:ntsteps) = t(2:length(t));t_step = tm-t;
% trapezoidal integration
for k = 1:ntsteps
ahm = inv(eye(s.NumStates) - 0.5*t_step(k).*s.a);
ahp = eye(s.NumStates) + 0.5*t_step(k)*s.a;
ahmp = ahm*ahp;
ahmhh = t_step(k)*ahm;
b = 0.5*s.b*(v_in(:,k)+v_in(:,k+1));
x(:,k+1) = ahmp*x(:,k)+ ahmhh*b;
end 
res = s.c*x + s.d*v_in;
figure
plot(t,res)
return