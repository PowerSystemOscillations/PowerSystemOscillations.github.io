function ssm = stsp2ss(s)
% coverts state space object to control system toolbox object
% requires the control system toolbox
ssm = ss(s.a,s.b,s.c,s.d);