% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.17

% sbestsp.mat: 2-area syst. with detailed gen. models and exciters,
%              d2asbe.m (state space)

clear all; close all; clc;
load('../mat/sbestsp.mat');                   % load data file

%-------------------------------------%
% fig 17

fig17a_name = './csv/ch9_fig17a.csv';
fig17b_name = './csv/ch9_fig17b.csv';

% 4-input, 4-output system: V_ref to V_m
G_4 = ss(a_mat,b_vr,c_v([1 2 6 7],:),zeros(4,4));
S_4 = eye(4) - G_4;
[SV_G4,W_G4] = sigma(G_4,{1e-2,1e3});
[SV_S4,W_S4] = sigma(S_4,{1e-2,1e3});
loglog(W_G4/(2*pi),SV_G4(1,:), W_S4/(2*pi),SV_S4(1,:));
legend('Comp. sen.','Sensitivity','location','best');
axis([0.01 100 1e-4 1e2]);
xlabel('Frequency (Hz)');

% complementary sensitivity table on p. 224
% [mag,phase] = bode(G_4,[0.01*2*pi]);
% real_imag = mag.*(cos(phase) + 1j*sin(phase));

% at 0.01 rad/sec - looks close except for 4,4 entry?
%    0.9922 - 0.0455i   0.0017 + 0.0012i  -0.0024 + 0.0048i   0.0125 + 0.0014i
%   -0.0078 - 0.0051i   0.9760 - 0.0451i   0.0037 - 0.0053i   0.0079 - 0.0129i
%    0.0020 + 0.0033i   0.0050 + 0.0078i   0.9856 - 0.0435i   0.0001 - 0.0003i
%   -0.0035 + 0.0013i   0.0056 + 0.0071i   0.0002 - 0.0058i  -0.2167 + 0.9512i
% at 0.1 rad/sec - same issue
%    0.9811 - 0.0086i  -0.0109 - 0.0288i   0.0185 - 0.0009i  -0.0145 - 0.0405i
%    0.0077 - 0.0022i   0.9359 - 0.0099i  -0.0123 - 0.0220i  -0.0290 - 0.0510i
%    0.0157 - 0.0027i   0.0373 - 0.0065i   0.9735 - 0.0069i  -0.0141 - 0.0272i
%   -0.0022 + 0.0190i   0.0448 - 0.0080i   0.0106 - 0.0023i  -0.2529 + 0.9021i
% at 2 rad/sec - the (4,4) entry looks more encouraging
%    0.9976 + 0.0890i  -0.1122 - 0.0078i  -0.0073 + 0.0055i  -0.0169 + 0.0036i
%    0.0959 + 0.0108i   0.5923 + 0.7916i  -0.0003 + 0.0078i  -0.0053 - 0.0131i
%   -0.0045 - 0.0034i  -0.0025 + 0.0108i   0.8123 - 0.5639i  -0.0257 + 0.0768i
%   -0.0022 + 0.0148i   0.0212 - 0.0196i  -0.0849 + 0.0252i   0.9675 - 0.1563i

% exporting data file
H17a = {'wg4','svg4'};
M17a = [W_G4.'/(2*pi); SV_G4(1,:)];

fid17a = fopen(fig17a_name,'w');
fprintf(fid17a,'%s,%s\n',H17a{:});
fprintf(fid17a,'%6e,%6e\n',M17a);
fclose(fid17a);

H17b = {'ws4','svs4'};
M17b = [W_S4.'/(2*pi); SV_S4(1,:)];

fid17b = fopen(fig17b_name,'w');
fprintf(fid17b,'%s,%s\n',H17b{:});
fprintf(fid17b,'%6e,%6e\n',M17b);
fclose(fid17b);

% eof
