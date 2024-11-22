% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.46

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');
load('../mat/dcpf1cont2.mat');                % damping control

%-------------------------------------%
% fig 46

fig46_name = './csv/ch10_fig46.csv';

fig46 = figure;
ax461 = subplot(2,1,1,'parent',fig46);
ax462 = subplot(2,1,2,'parent',fig46);

hold(ax461,'on');
hold(ax462,'on');

set(ax461,'xscale','log');
set(ax462,'xscale','log');
% set(ax461,'yscale','log');

s_cr = ss(s_cr.a,s_cr.b,s_cr.c,s_cr.d);
s_crmp = ss(s_crmp.a,s_crmp.b,s_crmp.c,s_crmp.d);

w_s = logspace(-2,2,256)*2*pi;
[mag_sr,ph_sr] = bode(s_cr,w_s);
[mag_srmp,ph_srmp] = bode(s_crmp,w_s);

plot(ax461,w_s/2/pi,20*log10(squeeze(mag_sr)),w_s/2/pi,20*log10(squeeze(mag_srmp)));
plot(ax462,w_s/2/pi,squeeze(wrapTo180(ph_sr)),w_s/2/pi,squeeze(wrapTo180(ph_srmp)));

legend(ax461,{'non-minimum phase','minimum phase'},'location','southwest');
legend(ax462,{'non-minimum phase','minimum phase'},'location','northwest');

xlabel(ax462,'Frequency (Hz)');
ylabel(ax461,'Gain (dB)');
ylabel(ax462,'Phase (deg)');

H46 = {'f','g','p','gr','pr'};
M46 = [w_s/2/pi; 20*log10(squeeze(mag_sr)).'; squeeze(wrapTo180(ph_sr)).'; ...
                 20*log10(squeeze(mag_srmp)).'; squeeze(wrapTo180(ph_srmp)).'];

fid46 = fopen(fig46_name,'w');
fprintf(fid46,'%s,%s,%s,%s,%s\n',H46{:});
fprintf(fid46,'%6e,%6e,%6e,%6e,%6e\n',M46);
fclose(fid46);

% eof
