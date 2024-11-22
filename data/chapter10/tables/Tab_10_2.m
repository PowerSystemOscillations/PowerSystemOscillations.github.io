% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 10.2

% dcpf1cont.mat: robust feedback control specification (state space)

clear all; close all; clc;
load('../mat/dcpf1cont.mat');

%-------------------------------------%
% table 2

s_c1 = ss(s_c1.a,s_c1.b,s_c1.c,s_c1.d);
s_cr1 = ss(s_cr1.a,s_cr1.b,s_cr1.c,s_cr1.d);

[p,z] = pzmap(s_cr1);

fprintf('\nTable 2. Poles and zeros of the robust feedback control.\n\n');
format longg
disp([flipud(round(p,4)),flipud(round(z,4))])

% eof
