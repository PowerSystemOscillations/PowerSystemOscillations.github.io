%% fig 10.33

clear all; close all; clc;
load('d2atcscs.mat');

fig33_name = './dat/ch10_fig33.dat';

fig33 = figure;
ax331 = subplot(2,1,1,'parent',fig33);
ax332 = subplot(2,1,2,'parent',fig33);
%
hold(ax331,'on');
hold(ax332,'on');
%
set(ax331,'xscale','log');
set(ax332,'xscale','log');
%set(ax331,'yscale','log');

sys_tcsc = ss(a_mat,b_tcsc(:,1),c_v(12,:),0);
[sys_tcsc_red,~] = balred(sys_tcsc,8);  % remove negligible states

w_s = [linspace(0.01,2,128),linspace(2.1,100,128)]*2*pi;
[mag_s,ph_s] = bode(sys_tcsc,w_s);
[mag_sr,ph_sr] = bode(sys_tcsc_red,w_s);

plot(ax331,w_s/2/pi,20*log10(squeeze(mag_s)),w_s/2/pi,20*log10(squeeze(mag_sr)));
plot(ax332,w_s/2/pi,squeeze(wrapTo180(ph_s)),w_s/2/pi,squeeze(wrapTo180(ph_sr)));

xlabel(ax332,'Frequency (Hz)');
ylabel(ax331,'Gain (dB)');
ylabel(ax332,'Phase (deg)');

H33 = {'f','g','p','gr','pr'};
M33 = [w_s/2/pi; 20*log10(squeeze(mag_s)).'; squeeze(wrapTo180(ph_s)).'; ...
                 20*log10(squeeze(mag_sr)).'; squeeze(wrapTo180(ph_sr)).'];

fid33 = fopen(fig33_name,'w');
fprintf(fid33,'%s,%s,%s,%s,%s\n',H33{:});    % must match number of columns
fprintf(fid33,'%6e,%6e,%6e,%6e,%6e\n',M33);  % must match number of columns
fclose(fid33);

% eof
