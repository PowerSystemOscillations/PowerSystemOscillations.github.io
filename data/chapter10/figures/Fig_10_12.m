% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.12

% d2adcem.mat: 2-area system with dc exciters and governors, base system

clear all; close all; clc;
load('../mat/d2adcem.mat');

%-------------------------------------%
% fig 12

fig12_name = './csv/ch10_fig12.csv';

fig12 = figure;
ax121 = subplot(2,1,1,'parent',fig12);
ax122 = subplot(2,1,2,'parent',fig12);
%
hold(ax121,'on');
hold(ax122,'on');
%
grid(ax121,'on');
grid(ax122,'on');
%
set(ax121,'xscale','log');
set(ax122,'xscale','log');
%set(ax121,'yscale','log');

sys_sv3 = ss(a_mat,b_svc(:,1),c_ilmf(5,:),0);
[sys_sv3red,~] = balred(sys_sv3,13);  % remove negligible states

w_s = [linspace(0.01,2,128),linspace(2.1,100,128)]*2*pi;
[mag_s,ph_s] = bode(sys_sv3,w_s);
[mag_sr,ph_sr] = bode(sys_sv3red,w_s);

plot(ax121,w_s/2/pi,20*log10(squeeze(mag_s)),w_s/2/pi,20*log10(squeeze(mag_sr)));
plot(ax122,w_s/2/pi,squeeze(wrapTo180(ph_s)),w_s/2/pi,squeeze(wrapTo180(ph_sr)));

xlabel(ax122,'Frequency (Hz)');
ylabel(ax121,'Gain (dB)');
ylabel(ax122,'Phase (deg)');

H12 = {'f','g','p','gr','pr'};
M12 = [w_s/2/pi; 20*log10(squeeze(mag_s)).'; squeeze(wrapTo180(ph_s)).'; ...
                 20*log10(squeeze(mag_sr)).'; squeeze(wrapTo180(ph_sr)).'];

fid12 = fopen(fig12_name,'w');
fprintf(fid12,'%s,%s,%s,%s,%s\n',H12{:});    % must match number of columns
fprintf(fid12,'%6e,%6e,%6e,%6e,%6e\n',M12);  % must match number of columns
fclose(fid12);

% eof
