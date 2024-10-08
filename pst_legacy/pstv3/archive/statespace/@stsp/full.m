function ss = full(s)
% converts a sparse state space object variables to full storage
a = full(s.a);
b = full(s.b);
c = full(s.c);
d = full(s.d);
ss = stsp(a,b,c,d);