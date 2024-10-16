%% table 3

clear all; close all; clc;
load('dcpf1cont.mat');

s_c1 = ss(s_c1.a,s_c1.b,s_c1.c,s_c1.d);
s_cr1 = ss(s_cr1.a,s_cr1.b,s_cr1.c,s_cr1.d);

[p,z] = pzmap(s_cr1);

disp([flipud(round(p,4)),flipud(round(z,4))])

% eof
