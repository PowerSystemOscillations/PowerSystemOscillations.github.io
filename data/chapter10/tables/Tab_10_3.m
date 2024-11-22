% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 10.3

% dcpf1cont2.mat: robust feedback control specification based on the
%                 unshaped system (state space)

clear all; close all; clc;
load('../mat/dcpf1cont2.mat');

%-------------------------------------%
% table 3

s_cr = ss(s_cr.a,s_cr.b,s_cr.c,s_cr.d);

[p,z] = pzmap(s_cr);

fprintf('\nTable 3. Poles and zeros of the robust control based on the unshaped system.\n\n');
format longg
disp([flipud(round(p,4)),flipud(round(z,4))])

% eof
