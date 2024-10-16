%% table 2

clear all; close all; clc;
load('dcpf1cont2.mat');

s_cr = ss(s_cr.a,s_cr.b,s_cr.c,s_cr.d);

[p,z] = pzmap(s_cr);

disp([flipud(round(p,4)),flipud(round(z,4))])

% eof
