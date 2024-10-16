function l = eq(s1,s2)
% logical equal for state space objects
%syntax l = eq(s1,s2) or s1==s2
%inputs two state space objects
% l = 1 if a,b,c,and d are identical for both s1 and s2
%   = 0 otherwise

% Author Graham Rogers
% Date August 1998
%(c) copyright Cherry Tree Scientific Software 1998

if ~isa(s1,'stsp')||~isa(s2,'stsp')
   error('both s1 and s2 must be state space objects')
else
   l = 1;
   if s1.NumStates~=s2.NumStates;l=0;
   elseif s1.NumOutputs~=s2.NumOutputs;l=0;
   elseif s1.NumInputs~=s2.NumInputs;l=0;
   elseif s1.a~=s2.a;l=0;
   elseif s1.b~=s2.b;l=0;
   elseif s1.c~=s2.c;l=0;
   elseif s1.d~=s2.d;l=0;
   end
end