%% fig 10.49

clear all; close all; clc;
load('d2aphvdcss.mat');
load('dcpf1cont2.mat');

fig49_name = './dat/ch10_fig49.dat';

fig49 = figure;
ax491 = subplot(2,1,1,'parent',fig49);
ax492 = subplot(2,1,2,'parent',fig49);
%
hold(ax491,'on');
hold(ax492,'on');
%
set(ax491,'xscale','log');
set(ax492,'xscale','log');
% set(ax491,'yscale','log');

s_cr = ss(s_cr.a,s_cr.b,s_cr.c,s_cr.d);
s_crmp = ss(s_crmp.a,s_crmp.b,s_crmp.c,s_crmp.d);

w_s = logspace(-2,2,256)*2*pi;
[mag_sr,ph_sr] = bode(s_cr,w_s);
[mag_srmp,ph_srmp] = bode(s_crmp,w_s);

plot(ax491,w_s/2/pi,20*log10(squeeze(mag_sr)),w_s/2/pi,20*log10(squeeze(mag_srmp)));
plot(ax492,w_s/2/pi,squeeze(wrapTo180(ph_sr)),w_s/2/pi,squeeze(wrapTo180(ph_srmp)));

legend(ax491,{'non-minimum phase','minimum phase'},'location','southwest');
legend(ax492,{'non-minimum phase','minimum phase'},'location','northwest');

xlabel(ax492,'Frequency (Hz)');
ylabel(ax491,'Gain (dB)');
ylabel(ax492,'Phase (deg)');

% H49 = {'f','g','p','gr','pr'};
% M49 = [w_s/2/pi; 20*log10(squeeze(mag_s)).'; squeeze(wrapTo180(ph_s)).'; ...
%                  20*log10(squeeze(mag_sr)).'; squeeze(wrapTo180(ph_sr)).'];
% 
% fid49 = fopen(fig49_name,'w');
% fprintf(fid49,'%s,%s,%s,%s,%s\n',H49{:});    % must match number of columns
% fprintf(fid49,'%6e,%6e,%6e,%6e,%6e\n',M49);  % must match number of columns
% fclose(fid49);

% eof
