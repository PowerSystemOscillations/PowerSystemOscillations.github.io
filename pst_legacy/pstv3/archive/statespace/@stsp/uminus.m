function sm = uminus(s)
% changes the sign of the output of a state space object
%syntax sm = minus(s)
%input s - a state space object
%output sm - a state space object having the same a,b matrices as s
%            the c & d matrices are the negative of those of s

if ~isa(s,'stsp')
   error('s must be a state space object')
else
   a=s.a;
   b=s.b;
   c=-s.c;
   d=-s.d;
   sm = stsp(a,b,c,d);
end