% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.35

% sbegpstsp.mat: 2-area syst. with detailed gen. models, exciters,
%                turbine/governors, and PSSs, d2asbegp.m (state space)

clear all; close all; clc;
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 35

fig35_name = './csv/ch9_fig35.csv';

% Fig. 9.31
w = logspace(-2,3,200);
b_tg = 25*b_pr;

% Combine exciter and governor into an 8x8 system
% Here we need scaling factors
G_8 = ss(a_mat,[0.05*b_vr 0.001*b_tg], ...
         [20*c_v([1 2 6 7],:); 1000*c_spd], zeros(8,8));
[SV_G8,W_G8] = sigma(G_8,w);

% Figure 9.32
W1e = 0.1*tf([0.1584 1],[0.001584 1]);
W1g = 0.1*tf([0.1584 1],[0.01584 1]);
W1em = [W1e 0 0 0; 0 W1e 0 0; 0 0 W1e 0; 0 0 0 W1e];
W1gm = [W1g 0 0 0; 0 W1g 0 0; 0 0 W1g 0; 0 0 0 W1g];
W1 = [W1em zeros(4,4); zeros(4,4) W1gm];
% Add frequency weights to G8
G_8 = ss(a_mat,[0.05*b_vr 0.001*b_tg], ...
         [20*c_v([1 2 6 7],:); 1000*c_spd], zeros(8,8));
G_8w = W1*G_8;
[SV_G8w,W_G8w] = sigma(G_8w,w);

% Figure 9.35
load('../mat/fig_9_35.mat');
% diagonal block perturbations
M = frd(G_8w,w);
% mubnds = mussv(M,[8 0]);
x = mubnds(1);
% [RESP1,FREQ1] = frdata(x);

figure, loglog(W_G8w/(2*pi),SV_G8w(1,:), FREQ1/(2*pi),squeeze(RESP1) )
legend('RS with full uncertainty', ...
       'RS with structured uncertainty','location','best');
%title('')
axis([0.01 100 1e-4 1e0]);
xlabel('Frequency (Hz)');

% exporting data file
H35 = {'wg8w','svg8w','freq1','resp1'};
M35 = [W_G8w.'/(2*pi); SV_G8w(1,:); FREQ1.'/(2*pi); squeeze(RESP1).'];

fid35 = fopen(fig35_name,'w');
fprintf(fid35,'%s,%s,%s,%s\n',H35{:});
fprintf(fid35,'%6e,%6e,%6e,%6e\n',M35);
fclose(fid35);

% eof
