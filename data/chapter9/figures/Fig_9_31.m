% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.31

% sbegpstsp.mat: 2-area syst. with detailed gen. models, exciters,
%                turbine/governors, and PSSs, d2asbegp.m (state space)

clear all; close all; clc;
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 31

fig31e_name = './csv/ch9_fig31e.csv';
fig31g_name = './csv/ch9_fig31g.csv';
fig31eg_name = './csv/ch9_fig31eg.csv';

G_4m = ss(a_mat,b_vr,c_v([1 2 6 7],:), zeros(4,4));
[SV_G4m,W_G4m] = sigma(G_4m,{1e-2,1e3});

% 4-input, 4-output system: turbine valve to gen speed
% apparently Graham added governor regulation gain of 25 to the
% complementary sensitivity function to raise it frequnecy response to
% unity at low frquency, as it does not have integral control
b_tg = 25*b_pr;
G_4sp = ss(a_mat,b_tg,c_spd,zeros(4,4));
[SV_G4sp,W_G4sp] = sigma(G_4sp,{1e-2,1e3});

% Combine exciter and governor into an 8x8 system
% Here we need scaling factors
G_8 = ss(a_mat,[0.05*b_vr 0.001*b_tg], ...
         [20*c_v([1 2 6 7],:); 1000*c_spd], zeros(8,8));
[SV_G8,W_G8] = sigma(G_8,{1e-2,1e3});
figure, loglog(W_G4m/(2*pi),SV_G4m(1,:), W_G4sp/(2*pi),SV_G4sp(1,:), ...
               W_G8/(2*pi),SV_G8(1,:));
legend('Exciter','Governor','Exciter and governor','location','best');
axis([0.01 100 1e-8 1e2]);
xlabel('Frequency (Hz)');

% exporting data file
H31e = {'wg4m','svg4m'};
M31e = [W_G4m.'/(2*pi); SV_G4m(1,:)];

fid31e = fopen(fig31e_name,'w');
fprintf(fid31e,'%s,%s\n',H31e{:});
fprintf(fid31e,'%6e,%6e\n',M31e);
fclose(fid31e);

H31g = {'wg4sp','svg4sp'};
M31g = [W_G4sp.'/(2*pi); SV_G4sp(1,:)];

fid31g = fopen(fig31g_name,'w');
fprintf(fid31g,'%s,%s\n',H31g{:});
fprintf(fid31g,'%6e,%6e\n',M31g);
fclose(fid31g);

H31eg = {'wg8','svg8'};
M31eg = [W_G8.'/(2*pi); SV_G8(1,:)];

fid31eg = fopen(fig31eg_name,'w');
fprintf(fid31eg,'%s,%s\n',H31eg{:});
fprintf(fid31eg,'%6e,%6e\n',M31eg);
fclose(fid31eg);

% eof
