% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.30

% d2asbegp.m: 2-area syst. with detailed gen. models and controls, post-fault
% sbegpstsp.mat: state-space model based on d2asbegp.m

clear all; close all; clc;
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 30

fig30_name = './csv/ch9_fig30.csv';

% 2-input, 4-output system: l_mod to V_m and frequency of 2 tie buses
G_42_ma = ss(a_mat, 0.1*b_lmod, ...
             [20*c_v([3 8],:); c_ang([3 8],:)], zeros(4,2));
% add rate filter to obtain c_f
rate = 1000*tf([1 0],(2*pi*60)*[0.01 1]);
G_42_mf = [1 0 0 0; 0 1 0 0; 0 0 rate 0; 0 0 0 rate]*G_42_ma;

[SV_G42_mf,W_G42_mf] = sigma(G_42_mf,{1e-2,1e3});

figure, loglog(W_G42_mf/(2*pi),SV_G42_mf(1,:));
axis([0.01 100 1e-2 1]);
xlabel('Frequency (Hz)');

% exporting data file
H30 = {'wg42mf','svg42mf'};
M30 = [W_G42_mf.'/(2*pi); SV_G42_mf(1,:)];

fid30 = fopen(fig30_name,'w');
fprintf(fid30,'%s,%s\n',H30{:});
fprintf(fid30,'%6e,%6e\n',M30);
fclose(fid30);

% eof
