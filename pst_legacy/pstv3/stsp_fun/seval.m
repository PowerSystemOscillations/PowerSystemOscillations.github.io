function [v,x] = seval(s,l,u)
% evaluates a state space object at a specified value of s
%Syntax: v=eval(s,l,u)
% Overrides the eval function for state space objects
% Inputs: s - a state space object
%         l - a scalar which may be complex
%         u - input column vector (length s.NumInputs)
% Output: v - the value of the state space output evaluated at l
%         v = s.c*inv(lI-s.a)*s.b*u + s.d*u
%         x = inv(lI-s.a)*s.b*u
% Author: Graham Rogers
% Date: September 1998
% (c) Copyright Cherry Tree Scientific Software 1998
% All rights reserved

NumStates = size(s.a,1);
NumInputs = size(s.b,2);
NumOutputs = size(s.c,1);

if nargin==2;u=ones(NumInputs,1);end
[r,c]=size(l);
if r~=1||c~=1
    error(' l must be a scalar quantity')
end
[r,c]=size(u);
if r ~= NumInputs
    error('the number of rows of u must equal the number of inputs of s')
elseif c~=1
    error('u must be a column vector')
end
ld = l*sparse(eye(NumStates));
al = sparse(zeros(NumStates));
al = -s.a + ld;
if cond(al)<1e6
    x = al\s.b*u;
else
    x = pinv(al)*s.b*u;
end

v = s.c*x + s.d*u;

% eof
