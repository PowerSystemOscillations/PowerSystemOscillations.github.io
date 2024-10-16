%% fig 10.45

clear all; close all; clc;
load('d2aphvdcss.mat');

fig45_name = './dat/ch10_fig45.dat';

fig45 = figure;
ax451 = subplot(2,1,1,'parent',fig45);
ax452 = subplot(2,1,2,'parent',fig45);
%
hold(ax451,'on');
hold(ax452,'on');
%
set(ax451,'xscale','log');
set(ax452,'xscale','log');
%set(ax451,'yscale','log');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:)-c_ang(9,:),d_angdcr(3,:)-d_angdcr(9,:));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);
[sys_dcr_red,~] = balred(sys_dcr*rate,8);  % remove negligible states

w_s = logspace(-2,2,256)*2*pi;
[mag_s,ph_s] = bode(sys_dcr*rate,w_s);
[mag_sr,ph_sr] = bode(sys_dcr_red,w_s);

plot(ax451,w_s/2/pi,20*log10(squeeze(mag_s)),w_s/2/pi,20*log10(squeeze(mag_sr)));
plot(ax452,w_s/2/pi,squeeze(wrapTo180(ph_s)),w_s/2/pi,squeeze(wrapTo180(ph_sr)));

legend(ax451,{'full','reduced'},'location','southeast');
legend(ax452,{'full','reduced'},'location','northeast');

xlabel(ax452,'Frequency (Hz)');
ylabel(ax451,'Gain (dB)');
ylabel(ax452,'Phase (deg)');

H45 = {'f','g','p','gr','pr'};
M45 = [w_s/2/pi; 20*log10(squeeze(mag_s)).'; squeeze(wrapTo180(ph_s)).'; ...
                 20*log10(squeeze(mag_sr)).'; squeeze(wrapTo180(ph_sr)).'];

fid45 = fopen(fig45_name,'w');
fprintf(fid45,'%s,%s,%s,%s,%s\n',H45{:});    % must match number of columns
fprintf(fid45,'%6e,%6e,%6e,%6e,%6e\n',M45);  % must match number of columns
fclose(fid45);

% eof
