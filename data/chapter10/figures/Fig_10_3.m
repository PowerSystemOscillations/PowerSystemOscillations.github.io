% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.3

% d2adcemss.mat: 2-area system with dc exciters and governors, base system

clear all; close all; clc;
load('../mat/d2adcemss.mat');

%-------------------------------------%
% fig 3

fig3_name = './csv/ch10_fig3.csv';

W_sv = logspace(-2,log10(100*2*pi),256);
G_m = ss(a_mat,0.1*b_lmod,20*c_v([3 8],:),zeros(2,2));
SV_m = sigma(G_m,W_sv);

% l_mod to tie bus V_m and bus frequency
G_a = ss(a_mat,0.1*b_lmod,c_ang([3 8],:),zeros(2,2));

% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_f = 1000*[rate 0; 0 rate]*G_a;
SV_f = sigma(G_f,W_sv);

figure, loglog(W_sv/(2*pi),SV_m(1,:), W_sv/(2*pi),SV_f(1,:));
legend('Bus voltage','Bus frequency','location','northeast');
axis([0.01 100 1e-3 1e0]);
xlabel('Frequency (Hz)');

H3 = {'f_sv','SV_m','SV_f'};
M3 = [W_sv/2/pi; SV_m(1,:); SV_f(1,:)];

fid3 = fopen(fig3_name,'w');
fprintf(fid3,'%s,%s,%s\n',H3{:});  % must match number of columns
fprintf(fid3,'%6e,%6e,%6e\n',M3);  % must match number of columns
fclose(fid3);

% eof
