function sys = stsp2sys(s)
% coverts state space object to mus analysis and synthesis toolbox sys matrix
% requires the mu analysis and synthesis toolbox
sys = pck(s.a,s.b,s.c,s.d);