% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.19

% d2adcem1ss.mat: 2-area test case, one line 3--101, svc control
% control.mat: state-space control specification

clear all; close all; clc;
load('../mat/d2adcem1ss.mat');
load('../mat/control.mat');

%-------------------------------------%
% fig 19

fig19_name = './csv/ch10_fig19.csv';

fig19 = figure;
ax191 = subplot(2,1,1,'parent',fig19);
ax192 = subplot(2,1,2,'parent',fig19);
%
hold(ax191,'on');
hold(ax192,'on');

sys_sv3 = ss(a_mat,[b_svc(:,1),b_lmod],[c_ilmf(5,:);c_v([3 8],:);c_ang([3 8],:)],0);

sc = ss(sc.a,sc.b,sc.c,sc.d);
scr = ss(scr.a,scr.b,scr.c,scr.d);
sys_c1 = 5*sc*scr;

sc2 = ss(sc2.a,sc2.b,sc2.c,sc2.d);
scr2 = ss(scr2.a,scr2.b,scr2.c,scr2.d);
sys_c2 = 5*sc2*scr2;

%sys_sv3_c1r = series(sys_c1,sys_sv3,[1,2,3],[1,2,3]);
sys_sv3_c1r = feedback(sys_sv3,sys_c1,1,1,1);
sys_sv3_c2r = feedback(sys_sv3,sys_c2,1,1,1);

%----------------------------------------%
% robust control 1

W_sv = logspace(-2,log10(100*2*pi),256);
G_m1 = ss(sys_sv3_c1r.a,0.1*sys_sv3_c1r.b(:,[2,3]),20*sys_sv3_c1r.c([2,3],:),0);
SV_m1 = sigma(G_m1,W_sv);

% l_mod to tie bus V_m and bus frequency
G_a1 = ss(sys_sv3_c1r.a,0.1*sys_sv3_c1r.b(:,[2,3]),sys_sv3_c1r.c([4,5],:),0);

% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_f1 = 1000*[rate 0; 0 rate]*G_a1;
SV_f1 = sigma(G_f1,W_sv);

%----------------------------------------%
% robust control 2

W_sv = logspace(-2,log10(100*2*pi),256);
G_m2 = ss(sys_sv3_c2r.a,0.1*sys_sv3_c2r.b(:,[2,3]),20*sys_sv3_c2r.c([2,3],:),0);
SV_m2 = sigma(G_m2,W_sv);

% l_mod to tie bus V_m and bus frequency
G_a2 = ss(sys_sv3_c2r.a,0.1*sys_sv3_c2r.b(:,[2,3]),sys_sv3_c2r.c([4,5],:),0);

% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_f2 = 1000*[rate 0; 0 rate]*G_a2;
SV_f2 = sigma(G_f2,W_sv);

plot(ax191,W_sv/(2*pi),SV_m1(1,:),W_sv/(2*pi),SV_m2(1,:));
set(ax191,'xscale','log','yscale','log');

plot(ax192,W_sv/(2*pi),SV_f1(1,:),W_sv/(2*pi),SV_f2(1,:));
set(ax192,'xscale','log','yscale','log');

legend(ax191,{'robust control 1','robust control 2'},'location','northeast');
legend(ax192,{'robust control 1','robust control 2'},'location','northeast');
axis(ax191,[1e-2 100 1e-3 1]);
axis(ax192,[1e-2 100 1e-2 1]);
xlabel('Frequency (Hz)');

H19 = {'f_sv','SV_m1','SV_m1','SV_f1','SV_f2'};
M19 = [W_sv/2/pi; SV_m1(1,:); SV_m2(1,:); SV_f1(1,:); SV_f2(1,:)];

fid19 = fopen(fig19_name,'w');
fprintf(fid19,'%s,%s,%s,%s,%s\n',H19{:});
fprintf(fid19,'%6e,%6e,%6e,%6e,%6e\n',M19);
fclose(fid19);

% eof
