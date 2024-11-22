% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.13

% d2adcem.mat: 2-area system with dc exciters, no svc,
%              d2adcem.m (state space)

clear all; close all; clc;
load('../mat/d2adcem.mat');
load('../mat/control.mat');                   % control specification

%-------------------------------------%
% fig 13

fig13_name = './csv/ch10_fig13.csv';

fig13 = figure;
ax131 = subplot(2,1,1,'parent',fig13);
ax132 = subplot(2,1,2,'parent',fig13);
%
hold(ax131,'on');
hold(ax132,'on');
%
set(ax131,'xscale','log');
set(ax132,'xscale','log');
%set(ax131,'yscale','log');

sys_sv3 = ss(a_mat,b_svc(:,1),c_ilmf(5,:),0);
[sys_sv3red,~] = balred(sys_sv3,13);          % remove negligible states

sc = ss(sc.a,sc.b,sc.c,sc.d);
scr = ss(scr.a,scr.b,scr.c,scr.d);
sys_c1 = 5*sc;

sc2 = ss(sc2.a,sc2.b,sc2.c,sc2.d);
scr2 = ss(scr2.a,scr2.b,scr2.c,scr2.d);
sys_c2 = 5*sc2;

sys_sv3red_c1 = sys_c1*sys_sv3red;
sys_sv3red_c2 = sys_c2*sys_sv3red;

w_s = [linspace(0.01,2,128),linspace(2.1,100,128)]*2*pi;
[mag_sv3red_c1,ph_sv3red_c1] = bode(sys_sv3red_c1,w_s);
[mag_sv3red_c2,ph_sv3red_c2] = bode(sys_sv3red_c2,w_s);

[mag_sv3red_cr1,ph_sv3red_cr1] = bode(sys_sv3red_c1*scr,w_s);
[mag_sv3red_cr2,ph_sv3red_cr2] = bode(sys_sv3red_c2*scr2,w_s);

plot(ax131,w_s/2/pi,20*log10(squeeze(mag_sv3red_c1)), ...
           w_s/2/pi,20*log10(squeeze(mag_sv3red_c2)));
plot(ax132,w_s/2/pi,squeeze(wrapTo180(ph_sv3red_c1)), ...
           w_s/2/pi,squeeze(wrapTo180(ph_sv3red_c2)));

xlabel(ax132,'Frequency (Hz)');
ylabel(ax131,'Gain (dB)');
ylabel(ax132,'Phase (deg)');

H13 = {'f','gc1','pc1','gc2','pc2'};
M13 = [w_s/2/pi; 20*log10(squeeze(mag_sv3red_c1)).'; squeeze(wrapTo180(ph_sv3red_c1)).'; ...
                 20*log10(squeeze(mag_sv3red_c2)).'; squeeze(wrapTo180(ph_sv3red_c2)).'];

fid13 = fopen(fig13_name,'w');
fprintf(fid13,'%s,%s,%s,%s,%s\n',H13{:});
fprintf(fid13,'%6e,%6e,%6e,%6e,%6e\n',M13);
fclose(fid13);

% eof
