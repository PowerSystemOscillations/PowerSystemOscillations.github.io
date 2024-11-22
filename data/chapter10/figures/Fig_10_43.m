% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.43

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');

%-------------------------------------%
% fig 43

fig43_name = './csv/ch10_fig43.csv';

fig43 = figure;
ax431 = subplot(2,1,1,'parent',fig43);
ax432 = subplot(2,1,2,'parent',fig43);
%
hold(ax431,'on');
hold(ax432,'on');
%
set(ax431,'xscale','log');
set(ax432,'xscale','log');
%set(ax431,'yscale','log');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:)-c_ang(9,:),d_angdcr(3,:)-d_angdcr(9,:));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);
[sys_dcr_red,~] = balred(sys_dcr*rate,8);  % remove negligible states

w_s = logspace(-2,2,256)*2*pi;
[mag_s,ph_s] = bode(sys_dcr*rate,w_s);
[mag_sr,ph_sr] = bode(sys_dcr_red,w_s);

plot(ax431,w_s/2/pi,20*log10(squeeze(mag_s)),w_s/2/pi,20*log10(squeeze(mag_sr)));
plot(ax432,w_s/2/pi,squeeze(wrapTo180(ph_s)),w_s/2/pi,squeeze(wrapTo180(ph_sr)));

legend(ax431,{'full','reduced'},'location','southeast');
legend(ax432,{'full','reduced'},'location','northeast');

xlabel(ax432,'Frequency (Hz)');
ylabel(ax431,'Gain (dB)');
ylabel(ax432,'Phase (deg)');

H43 = {'f','g','p','gr','pr'};
M43 = [w_s/2/pi; 20*log10(squeeze(mag_s)).'; squeeze(wrapTo180(ph_s)).'; ...
                 20*log10(squeeze(mag_sr)).'; squeeze(wrapTo180(ph_sr)).'];

fid43 = fopen(fig43_name,'w');
fprintf(fid43,'%s,%s,%s,%s,%s\n',H43{:});    % must match number of columns
fprintf(fid43,'%6e,%6e,%6e,%6e,%6e\n',M43);  % must match number of columns
fclose(fid43);

% eof
