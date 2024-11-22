% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.9

% d2adcem.mat: 2-area system with dc exciters, no svc,
%              d2adcem.m (state space)

clear all; close all; clc;
load('../mat/d2adcem.mat');

%-------------------------------------%
% fig 9

fig9_name = './csv/ch10_fig9.csv';

fig9 = figure;
ax91 = subplot(2,1,1,'parent',fig9);
ax92 = subplot(2,1,2,'parent',fig9);
%
hold(ax91,'on');
hold(ax92,'on');
%
set(ax91,'xscale','log');
set(ax92,'xscale','log');
%set(ax91,'yscale','log');

c1 = tf([1,0],conv([1,1],[10,1]));
c2 = tf([0.08,0,0],conv(conv([0.5,1],[0.4,1]),conv([0.5,1],[0.4,1])));

w_c = logspace(log10(0.01*2*pi),log10(100*2*pi),256);
[mag_c1,ph_c1] = bode(c1,w_c);
[mag_c2,ph_c2] = bode(c2,w_c);

plot(ax91,w_c/2/pi,20*log10(squeeze(mag_c1)),w_c/2/pi,20*log10(squeeze(mag_c2)));
plot(ax92,w_c/2/pi,squeeze(ph_c1),w_c/2/pi,squeeze(ph_c2));

legend(ax91,{'control 1','control 2'},'location','southwest');
legend(ax92,{'control 1','control 2'},'location','northeast');

xlabel(ax92,'Frequency (Hz)');
ylabel(ax91,'Gain (dB)');
ylabel(ax92,'Phase (deg)');

H9 = {'f','gc1','pc1','gc2','pc2'};
M9 = [w_c/2/pi; 20*log10(squeeze(mag_c1)).'; squeeze(ph_c1).'; ...
      20*log10(squeeze(mag_c2)).'; squeeze(ph_c2).'];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
