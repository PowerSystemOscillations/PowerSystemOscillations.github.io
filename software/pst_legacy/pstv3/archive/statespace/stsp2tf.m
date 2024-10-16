function t = stsp2tf(s)
% converts state space object to a trasfer function object
% syntax: t = ss2tf(s)
% s must have one input and one output
if ~isa(s,'stsp')
   error('s must be a state space object')
elseif s.NumInputs~=1||s.NumOutputs~=1
   error('single input/single output systems only')
else
 ssm = stsp2ss(s);
 t=tf(ssm,'inv');
end
      