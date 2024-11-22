% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.28

% d2atcscs.mat: 2-area test case dc exciters and tcsc control

clear all; close all; clc;
load('../mat/d2atcscs.mat');

%-------------------------------------%
% fig 28

fig28_name = './csv/ch10_fig28.csv';

fig28 = figure;
ax281 = subplot(2,1,1,'parent',fig28);
ax282 = subplot(2,1,2,'parent',fig28);
%
hold(ax281,'on');
hold(ax282,'on');
%
set(ax281,'xscale','log');
set(ax282,'xscale','log');
%set(ax281,'yscale','log');

cn = 100*conv([1,0],conv([0.1,1],[0.1,1]));
cd = conv([1,1],conv([0.05,1],conv([0.5,1],[0.5,1])));
c1 = tf(cn,cd);

sys_tcsc = ss(a_mat,b_tcsc(:,1),c_v(12,:),0);
sys_tcsc_c1 = c1*sys_tcsc;

w_c = logspace(log10(0.01*2*pi),log10(100*2*pi),256);
[mag_c1,ph_c1] = bode(c1,w_c);

plot(ax281,w_c/2/pi,20*log10(squeeze(mag_c1)));
plot(ax282,w_c/2/pi,squeeze(ph_c1));

xlabel(ax282,'Frequency (Hz)');
ylabel(ax281,'Gain (dB)');
ylabel(ax282,'Phase (deg)');

% exporting data

H28 = {'f','gc1','pc1'};
M28 = [w_c/2/pi; 20*log10(squeeze(mag_c1)).'; squeeze(ph_c1).'];

fid28 = fopen(fig28_name,'w');
fprintf(fid28,'%s,%s,%s\n',H28{:});
fprintf(fid28,'%6e,%6e,%6e\n',M28);
fclose(fid28);

% eof
