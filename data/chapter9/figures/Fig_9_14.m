% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.14

% sbstsp.mat: 2-area syst. with detailed gen. models d2asb.m (state space)

clear all; close all; clc;                    % reset workspace
run('../cases/d2asb.m');
load('../mat/sbstsp.mat');                    % load data file

%-------------------------------------%
% fig 14

% create b_Efd input columns
[n1,n2] = size(a_mat);
b_Efd = zeros(n1,4);
for i = 1:4
    b_Efd((i-1)*6 + 3,i) = 1/mac_con(i,9);
end

% 6-input, 4-output system
G = ss(a_mat,[b_Efd b_lmod],[c_v([3 8],:); c_ang([3 8],:)],zeros(4,6));
% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_vf = [1 0 0 0; 0 1 0 0; 0 0 rate 0; 0 0 0 rate]*G;

% scaling of inputs and outputs according to (9.17) p. 214
b_scaled = G_vf.b * diag([10,10,10,10,0.1,0.1]);
c_scaled = diag([20,20,1000,1000]) * G_vf.c;
G_scaled = ss(G_vf.a,b_scaled,c_scaled,G_vf.d);

% we have to separate the inputs and outputs into 4 different plots
% TF 1
G_scaled_em = ss(G_scaled.a, G_scaled.b(:,1:4), G_scaled.c(1:2,:), ...
                 G_scaled.d(1:2,1:4));
% figure, sigma(G_scaled_em);
[SV_em,W_em] = sigma(G_scaled_em,{1e-2,1e3});
cn_em = SV_em(1,:)./SV_em(2,:);               % condition number

% TF 2
G_scaled_ef = ss(G_scaled.a, G_scaled.b(:,1:4), G_scaled.c(3:4,:), ...
                 G_scaled.d(3:4,1:4));
% figure, sigma(G_scaled_ef)
[SV_ef,W_ef] = sigma(G_scaled_ef,{1e-2,1e3});
cn_ef = SV_ef(1,:)./SV_ef(2,:);               % condition number

% TF 3
G_scaled_lm = ss(G_scaled.a, G_scaled.b(:,5:6), G_scaled.c(1:2,:), ...
                 G_scaled.d(1:2,5:6));
% figure, sigma(G_scaled_lm)
[SV_lm,W_lm] = sigma(G_scaled_lm,{1e-2,1e3});
cn_lm = SV_lm(1,:)./SV_lm(2,:);               % condition number

% TF 4
G_scaled_lf = ss(G_scaled.a, G_scaled.b(:,5:6), G_scaled.c(3:4,:), ...
                 G_scaled.d(3:4,5:6));
% figure, sigma(G_scaled_lf)
[SV_lf,W_lf] = sigma(G_scaled_lf,{1e-2,1e3});
cn_lf = SV_lf(1,:)./SV_lf(2,:);               % condition number

fig14 = figure;
ax14{1} = subplot(1,1,1,'parent',fig14);
hold(ax14{1},'on');

plot(ax14{1},W_ef/(2*pi),[SV_ef; cn_ef]);
legend(ax14{1},'smx','smn','cn');

set(ax14{1},'xscale','log');
set(ax14{1},'yscale','log');
axis(ax14{1},[0.01 100 1e-2 1e5]);

xlabel(ax14{1},'Frequency (Hz)');

% eof
