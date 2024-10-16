% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.19

% d2asbep.m: 2-area syst. with detailed gen. models and exciters, post-fault
% sbepstsp.mat: state-space model based on d2asbep.m

clear all; close all; clc;
run('../cases/d2asbe.m');
load('../mat/sbepstsp.mat');                   % load data file

%-------------------------------------%
% fig 19

fig19a_name = './csv/ch9_fig19a.csv';
fig19b_name = './csv/ch9_fig19b.csv';

% 4-input, 4-output system: V_ref to V_m
G_4 = ss(a_mat,b_vr,c_v([1 2 6 7],:), zeros(4,4));
S_4 = eye(4) - G_4;
[SV_G4,W_G4] = sigma(G_4,{1e-2,1e3});
[SV_S4,W_S4] = sigma(S_4,{1e-2,1e3});
loglog(W_G4/(2*pi),SV_G4(1,:), W_S4/(2*pi),SV_S4(1,:));
legend('Comp. sen.','Sensitivity','location','best');
axis([0.01 100 1e-4 1e1]);
xlabel('Frequency (Hz)');

% exporting data file
H19a = {'wg4','svg4'};
M19a = [W_G4.'/(2*pi); SV_G4(1,:)];

fid19a = fopen(fig19a_name,'w');
fprintf(fid19a,'%s,%s\n',H19a{:});
fprintf(fid19a,'%6e,%6e\n',M19a);
fclose(fid19a);

H19b = {'ws4','svs4'};
M19b = [W_S4.'/(2*pi); SV_S4(1,:)];

fid19b = fopen(fig19b_name,'w');
fprintf(fid19b,'%s,%s\n',H19b{:});
fprintf(fid19b,'%6e,%6e\n',M19b);
fclose(fid19b);

% eof
