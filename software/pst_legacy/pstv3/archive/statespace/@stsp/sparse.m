function ss = sparse(s)
% converts a state space object variables to sparse storage
a = sparse(s.a);
b = sparse(s.b);
c = sparse(s.c);
d = sparse(s.d);
ss = stsp(a,b,c,d);