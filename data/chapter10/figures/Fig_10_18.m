% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.18

% d2adcem1ss.mat: 2-area system with dc exciters, one line 3--101,
%                 svc control (state space)

clear all; close all; clc;
load('../mat/d2adcem1ss.mat');
load('../mat/control.mat');                   % control specification

%-------------------------------------%
% fig 18

Fs = 30;                                      % sample rate
tt = 0:1/Fs:10;                               % time vector

fig18_name = './csv/ch10_fig18.csv';

fig18 = figure;
ax181 = subplot(2,1,1,'parent',fig18);
ax182 = subplot(2,1,2,'parent',fig18);
%
hold(ax181,'on');
hold(ax182,'on');

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

ts = 0:0.001:10;
G_m1 = ss(sys_sv3_c1r.a,0.1*sum(sys_sv3_c1r.b(:,[2,3]),2),20*sys_sv3_c1r.c([2,3],:),0);
[y1,t1] = step(G_m1,ts);
plot(ax181,t1,y1(:,[1 2]));                   % upper half of Fig. 10.18
legend(ax181,'bus 3 v','bus 13 v','location','best')

%----------------------------------------%
% robust control 2

G_m2 = ss(sys_sv3_c2r.a,0.1*sum(sys_sv3_c2r.b(:,[2,3]),2),20*sys_sv3_c2r.c([2,3],:),0);
[y2,t2] = step(G_m2,ts);
plot(ax182,t2,y2(:,[1 2]));                   % lower half of Fig. 10.18
legend(ax182,'bus 3 v','bus 13 v','location','best')

ylabel(ax181,'Voltage dev. (pu)');
ylabel(ax182,'Voltage dev. (pu)');
xlabel(ax182,'Time (s)');

y_v_dec = interp1(t1,[y1,y2],tt).';           % downsampling

H18 = {'t','y1c1','y2c1','y1c2','y2c2'};
M18 = [tt; y_v_dec];

fid18 = fopen(fig18_name,'w');
fprintf(fid18,'%s,%s,%s,%s,%s\n',H18{:});
fprintf(fid18,'%6e,%6e,%6e,%6e,%6e\n',M18);
fclose(fid18);

% eof
