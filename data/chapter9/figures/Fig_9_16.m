% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.16

% sbstsp.mat: 2-area syst. with detailed gen. models d2asb.m (state space)

clear all; close all; clc;
load('../mat/sbstsp.mat');             % based on d2asb.m

%-------------------------------------%
% fig 16

fig16_name = './csv/ch9_fig16.csv';

% turbine governor model
h_par = 0.25 + tf([0,0.75],[5,1]);  % parallel section
h_gov = series(series(tf([0,1],[0.1,1]),tf([0,1],[0.5,1])),h_par);
G_gov = append(h_gov,h_gov,h_gov,h_gov);

% 4-input, 4-output system: turbine valve to gen bus voltage magnitude
G = ss(a_mat,b_pm,c_v([3 8],:),zeros(2,4));
G_casc = series(G_gov,G,[1,2,3,4],[1,2,3,4]);

% scaling of inputs and outputs according to (9.17) p. 214
b_scaled = G_casc.b * diag([0.025,0.025,0.025,0.025]);
c_scaled = diag([20,20]) * G_casc.c;
G_scaled = ss(G_casc.a,b_scaled,c_scaled,G_casc.d);

% 4-input, 4-output system: turbine valve to gen bus frequency
G = ss(a_mat,b_pm,c_ang([3 8],:),zeros(2,4));
G_casc = series(G_gov,G,[1,2,3,4],[1,2,3,4]);

% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_gf = [rate 0; 0 rate]*G_casc;

% scaling of inputs and outputs according to (9.17) p. 214
b_scaled = G_gf.b * diag([0.025,0.025,0.025,0.025]);
c_scaled = diag([1000,1000]) * G_gf.c;
G_gf_scaled = ss(G_gf.a,b_scaled,c_scaled,G_gf.d);

% figure handles
fig16 = figure;
for ii = 1:2
    ax16{ii} = subplot(1,2,ii,'parent',fig16);
    hold(ax16{ii},'on');
end

% make sigma plots
% figure, sigma(G_scaled)
[SV_gm, W_gm] = sigma(G_scaled,{1e-2,1e3});
[SV_gf, W_gf] = sigma(G_gf_scaled,{1e-2,1e3});
cn_gm = SV_gm(1,:)./SV_gm(2,:);               % condition number
cn_gf = SV_gf(1,:)./SV_gf(2,:);               % condition number
plot(ax16{1},W_gm/(2*pi),[SV_gm(1,:); SV_gm(2,:); cn_gm]);
plot(ax16{2},W_gf/(2*pi),[SV_gf(1,:); SV_gf(2,:);cn_gf])
legend(ax16{1},'smx','smn','cn','location','best');
legend(ax16{2},'smx','smn','cn','location','best');

set(ax16{1},'xscale','log');
set(ax16{1},'yscale','log');
axis(ax16{1},[0.01 100 1e-12 1e6]);
set(ax16{2},'xscale','log');
set(ax16{2},'yscale','log');
axis(ax16{2},[0.01 100 1e-12 1e6]);

xlabel(ax16{1},'Frequency (Hz)');
xlabel(ax16{2},'Frequency (Hz)');

% exporting data file
H16 = {'wgm','wgf', ...
    'svgmx','svgmn','cngm', ...
    'svgfx','svgfn','cngf'};
M16 = [W_gm.'/(2*pi); W_gf.'/(2*pi); ...
    SV_gm(1,:); SV_gm(2,:); cn_gm; ...
    SV_gf(1,:); SV_gf(2,:); cn_gf;];

fid16 = fopen(fig16_name,'w');
fprintf(fid16,'%s,%s,%s,%s,%s,%s,%s,%s\n',H16{:});
fprintf(fid16,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M16);
fclose(fid16);

% eof
