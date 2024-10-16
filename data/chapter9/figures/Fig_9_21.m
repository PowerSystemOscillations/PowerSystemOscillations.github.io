% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.21

% d2asbegp.m: 2-area syst. with detailed gen. models and controls, post-fault
% sbegpstsp.mat: state-space model based on d2asbegp.m

clear all; close all; clc;
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 21

fig21a_name = './csv/ch9_fig21a.csv';
fig21b_name = './csv/ch9_fig21b.csv';

% Graham added a gain of 25 to raise the complementary sensitivity
b_tg = 25*b_pr;

% 4-input, 4-output system: turbine valve to gen speed
G_4 = ss(a_mat,b_tg,c_spd,zeros(4,4));
S_4 = eye(4) - G_4;
[SV_G4,W_G4] = sigma(G_4,{1e-2,1e3});
[SV_S4,W_S4] = sigma(S_4,{1e-2,1e3});
loglog(W_G4/(2*pi),SV_G4(1,:),W_S4/(2*pi),SV_S4(1,:));
legend('Comp. sen.','Sensitivity','location','best');
axis([0.01 100 1e-8 1e2]);
xlabel('Frequency (Hz)');

% exporting data file
H21a = {'wg4','svg4'};
M21a = [W_G4.'/(2*pi); SV_G4(1,:)];

fid21a = fopen(fig21a_name,'w');
fprintf(fid21a,'%s,%s\n',H21a{:});
fprintf(fid21a,'%6e,%6e\n',M21a);
fclose(fid21a);

H21b = {'ws4','svs4'};
M21b = [W_S4.'/(2*pi); SV_S4(1,:)];

fid21b = fopen(fig21b_name,'w');
fprintf(fid21b,'%s,%s\n',H21b{:});
fprintf(fid21b,'%6e,%6e\n',M21b);
fclose(fid21b);

% eof
