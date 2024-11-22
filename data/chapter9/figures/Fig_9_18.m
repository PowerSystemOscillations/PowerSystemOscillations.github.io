% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.18

% sbestsp.mat: 2-area syst. with detailed gen. models and exciters,
%              d2asbe.m (state space)

clear all; close all; clc;
load('../mat/sbestsp.mat');                   % load data file

%-------------------------------------%
% fig 18

fig18a_name = './csv/ch9_fig18a.csv';
fig18b_name = './csv/ch9_fig18b.csv';

% 2-input, 2-output system: l_mod to V_m of 2 tie buses
G_22_m = ss(a_mat,0.1*b_lmod,20*c_v([3 8],:),zeros(2,2));
[SV_G22_m,W_G22_m] = sigma(G_22_m,{1e-2,1e3});

% l_mod to tie bus V_m and bus frequency
G_22_a = ss(a_mat,0.1*b_lmod,c_ang([3 8],:),zeros(2,2));
% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_22_f = 1000*[rate 0; 0 rate]*G_22_a;

[SV_G22_f,W_G22_f] = sigma(G_22_f,{1e-2,1e3});
figure, loglog(W_G22_m/(2*pi),SV_G22_m(1,:), W_G22_f/(2*pi),SV_G22_f(1,:));
legend('Bus voltage','Bus frequency','location','best');
axis([0.01 100 1e-3 1e1]);
xlabel('Frequency (Hz)');

% exporting data file
H18a = {'wg22m','svg22m'};
M18a = [W_G22_m.'/(2*pi); SV_G22_m(1,:)];

fid18a = fopen(fig18a_name,'w');
fprintf(fid18a,'%s,%s\n',H18a{:});
fprintf(fid18a,'%6e,%6e\n',M18a);
fclose(fid18a);

H18b = {'wg22f','svg22f'};
M18b = [W_G22_f.'/(2*pi); SV_G22_f(1,:)];

fid18b = fopen(fig18b_name,'w');
fprintf(fid18b,'%s,%s\n',H18b{:});
fprintf(fid18b,'%6e,%6e\n',M18b);
fclose(fid18b);

% eof
