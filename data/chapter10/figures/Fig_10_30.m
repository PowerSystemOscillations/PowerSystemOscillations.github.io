% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.30

% d2atcscs.mat: 2-area test case dc exciters and tcsc control

clear all; close all; clc;
load('../mat/d2atcscs.mat');

%-------------------------------------%
% fig 30

fig30_name = './csv/ch10_fig30.csv';

fig30 = figure;
ax301 = subplot(2,1,1,'parent',fig30);
ax302 = subplot(2,1,2,'parent',fig30);
%
hold(ax301,'on');
hold(ax302,'on');
%
set(ax301,'xscale','log');
set(ax302,'xscale','log');
%set(ax301,'yscale','log');

sys_tcsc = ss(a_mat,b_tcsc(:,1),c_v(12,:),0);
[sys_tcsc_red,~] = balred(sys_tcsc,8);        % remove negligible states

w_s = [linspace(0.01,2,128),linspace(2.1,100,128)]*2*pi;
[mag_s,ph_s] = bode(sys_tcsc,w_s);
[mag_sr,ph_sr] = bode(sys_tcsc_red,w_s);

plot(ax301,w_s/2/pi,20*log10(squeeze(mag_s)),w_s/2/pi,20*log10(squeeze(mag_sr)));
plot(ax302,w_s/2/pi,squeeze(wrapTo180(ph_s)),w_s/2/pi,squeeze(wrapTo180(ph_sr)));

xlabel(ax302,'Frequency (Hz)');
ylabel(ax301,'Gain (dB)');
ylabel(ax302,'Phase (deg)');

% exporting data

H30 = {'f','g','p','gr','pr'};
M30 = [w_s/2/pi; 20*log10(squeeze(mag_s)).'; squeeze(wrapTo180(ph_s)).'; ...
                 20*log10(squeeze(mag_sr)).'; squeeze(wrapTo180(ph_sr)).'];

fid30 = fopen(fig30_name,'w');
fprintf(fid30,'%s,%s,%s,%s,%s\n',H30{:});
fprintf(fid30,'%6e,%6e,%6e,%6e,%6e\n',M30);
fclose(fid30);

% eof
