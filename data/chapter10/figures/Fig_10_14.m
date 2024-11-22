% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.14

% d2adcem.mat: 2-area system with dc exciters, no svc,
%              d2adcem.m (state space)

clear all; close all; clc;
load('../mat/d2adcem.mat');
load('../mat/control.mat');                   % control specification

%-------------------------------------%
% fig 14

fig14_name = './csv/ch10_fig14.csv';

fig14 = figure;
ax141 = subplot(2,1,1,'parent',fig14);
ax142 = subplot(2,1,2,'parent',fig14);

hold(ax141,'on');
hold(ax142,'on');

set(ax141,'xscale','log');
set(ax142,'xscale','log');

sys_sv3 = ss(a_mat,b_svc(:,1),c_ilmf(5,:),0);
[sys_sv3red,~] = balred(sys_sv3,13);           % remove negligible states

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

% plotting

plot(ax141,w_s/2/pi,20*log10(squeeze(mag_sv3red_cr1)), ...
           w_s/2/pi,20*log10(squeeze(mag_sv3red_cr2)));
plot(ax142,w_s/2/pi,squeeze(wrapTo180(ph_sv3red_cr1)), ...
           w_s/2/pi,squeeze(wrapTo180(ph_sv3red_cr2)));

xlabel(ax142,'Frequency (Hz)');
ylabel(ax141,'Gain (dB)');
ylabel(ax142,'Phase (deg)');

% exporting data

H14 = {'f','gc1','pc1','gc2','pc2'};
M14 = [w_s/2/pi; 20*log10(squeeze(mag_sv3red_cr1)).'; squeeze(wrapTo180(ph_sv3red_cr1)).'; ...
                 20*log10(squeeze(mag_sv3red_cr2)).'; squeeze(wrapTo180(ph_sv3red_cr2)).'];

fid14 = fopen(fig14_name,'w');
fprintf(fid14,'%s,%s,%s,%s,%s\n',H14{:});
fprintf(fid14,'%6e,%6e,%6e,%6e,%6e\n',M14);
fclose(fid14);

% eof
