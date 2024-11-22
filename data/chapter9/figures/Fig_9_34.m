% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.34

% sbegpstsp.mat: 2-area syst. with detailed gen. models, exciters,
%                turbine/governors, and PSSs, d2asbegp.m (state space)

clear all; close all; clc;
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 34

fig34_name = './csv/ch9_fig34.csv';

load('../mat/fig_9_34_a.mat'),load('../mat/fig_9_34_b.mat')
z_npw = SV_G42_mf; % nominal performance
W1_Tiw = SV_G8w;   % robust stability
% promising, but does not exactly match the book
% Multiplying the G_tc term by a constant value > 1 improves the approx.,
% but still does not work.
% The most important part is at 3 Hz (interarea mode)
RHS_9_40w = (1 - z_npw)./(1 - z_npw + 1*G_tc_S_iw(1,:).*K_S_o_G_vmw(1,:));
figure, loglog(w/(2*pi),W1_Tiw(1,:), w/(2*pi),RHS_9_40w(1,:));
legend('Stability measure','Performance limit','location','best');
axis([0.01 100 1e-3 1e0]);
xlabel('Frequency (Hz)');

% exporting data file
H34 = {'w','w1Tiw','rhs940w'};
M34 = [w/(2*pi); W1_Tiw(1,:); RHS_9_40w(1,:)];

fid34 = fopen(fig34_name,'w');
fprintf(fid34,'%s,%s,%s\n',H34{:});
fprintf(fid34,'%6e,%6e,%6e\n',M34);
fclose(fid34);

% eof
