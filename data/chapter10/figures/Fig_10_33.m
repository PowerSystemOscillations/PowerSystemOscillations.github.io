% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.33

% d2atcscs.mat: 2-area test case dc exciters and tcsc control

clear all; close all; clc;
load('../mat/d2atcscs.mat');
load('../mat/control6.mat');                  % tcsc control

%-------------------------------------%
% fig 33

fig33_name = './csv/ch10_fig33.csv';

fig33 = figure;
ax331 = subplot(1,1,1,'parent',fig33);
hold(ax331,'on');

sys_tcsc = ss(a_mat,[b_tcsc(:,1),b_lmod],[c_v(12,:);c_v([3 8],:);c_ang([3 8],:)],0);

sc3 = ss(sc3.a,sc3.b,sc3.c,sc3.d);
scr = ss(scr.a,scr.b,scr.c,scr.d);
sys_rc = 100*sc3*scr;

sys_tcsc_rc = feedback(sys_tcsc,sys_rc,1,1,1);

%-------------------------------------%
% robust control 1

W_sv = logspace(-2,log10(100*2*pi),256);
G_m = ss(sys_tcsc_rc.a,0.1*sys_tcsc_rc.b(:,[2,3]),20*sys_tcsc_rc.c([2,3],:),0);
SV_m = sigma(G_m,W_sv);

% l_mod to tie bus V_m and bus frequency
G_a = ss(sys_tcsc_rc.a,0.1*sys_tcsc_rc.b(:,[2,3]),sys_tcsc_rc.c([4,5],:),0);

% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_f = 1000*[rate 0; 0 rate]*G_a;
SV_f = sigma(G_f,W_sv);

plot(ax331,W_sv/(2*pi),SV_m(1,:),W_sv/(2*pi),SV_f(1,:));
set(ax331,'xscale','log','yscale','log');

legend(ax331,{'bus voltage','bus frequency'},'location','northeast');

axis(ax331,[1e-2 100 1e-3 1]);
xlabel('Frequency (Hz)');

% exporting data

H33 = {'f_sv','SV_m','SV_f'};
M33 = [W_sv/2/pi; SV_m(1,:); SV_f(1,:)];

fid33 = fopen(fig33_name,'w');
fprintf(fid33,'%s,%s,%s\n',H33{:});
fprintf(fid33,'%6e,%6e,%6e\n',M33);
fclose(fid33);

% eof
