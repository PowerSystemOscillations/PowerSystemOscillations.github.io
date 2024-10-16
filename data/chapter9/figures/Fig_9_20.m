% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.20

% d2asbep.m: 2-area syst. with detailed gen. models and exciters, post-fault
% sbepstsp.mat: state-space model based on d2asbep.m

clear all; close all; clc;
run('../cases/d2asbe.m');
load('../mat/sbepstsp.mat');                  % load data file

%-------------------------------------%
% fig 20

fig20a_name = './csv/ch9_fig20a.csv';
fig20b_name = './csv/ch9_fig20b.csv';

% 2-input, 2-output system: l_mod to V_m of 2 tie buses
G_22_m = ss(a_mat,0.1*b_lmod,20*c_v([3 8],:), zeros(2,2));
%
[SV_G22_m,W_G22_m] = sigma(G_22_m,{1e-2,1e3});

% l_mod to tie bus V_m and bus frequency
G_22_a = ss(a_mat,0.1*b_lmod,c_ang([3 8],:), zeros(2,2));
% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_22_f = 1000*[rate 0; 0 rate]*G_22_a;

[SV_G22_f,W_G22_f] = sigma(G_22_f,{1e-2,1e3});
figure, loglog(W_G22_m/(2*pi),SV_G22_m(1,:),W_G22_f/(2*pi),SV_G22_f(1,:));
legend('Bus voltage','Bus frequency','location','best');
axis([0.01 100 1e-3 1e1]);
xlabel('Frequency (Hz)');

% exporting data file
H20a = {'wg22m','svg22m'};
M20a = [W_G22_m.'/(2*pi); SV_G22_m(1,:)];

fid20a = fopen(fig20a_name,'w');
fprintf(fid20a,'%s,%s\n',H20a{:});
fprintf(fid20a,'%6e,%6e\n',M20a);
fclose(fid20a);

H20b = {'wg22f','svg22f'};
M20b = [W_G22_f.'/(2*pi); SV_G22_f(1,:)];

fid20b = fopen(fig20b_name,'w');
fprintf(fid20b,'%s,%s\n',H20b{:});
fprintf(fid20b,'%6e,%6e\n',M20b);
fclose(fid20b);

% eof
