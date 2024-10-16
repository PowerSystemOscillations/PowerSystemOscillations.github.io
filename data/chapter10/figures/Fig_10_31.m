%% fig 10.31

clear all; close all; clc;
load('d2atcscs.mat');

fig31_name = './dat/ch10_fig31.dat';

fig31 = figure;
ax311 = subplot(2,1,1,'parent',fig31);
ax312 = subplot(2,1,2,'parent',fig31);
%
hold(ax311,'on');
hold(ax312,'on');
%
set(ax311,'xscale','log');
set(ax312,'xscale','log');
%set(ax311,'yscale','log');

cn = 100*conv([1,0],conv([0.1,1],[0.1,1]));
cd = conv([1,1],conv([0.05,1],conv([0.5,1],[0.5,1])));
c1 = tf(cn,cd);

sys_tcsc = ss(a_mat,b_tcsc(:,1),c_v(12,:),0);
sys_tcsc_c1 = c1*sys_tcsc;

w_c = logspace(log10(0.01*2*pi),log10(100*2*pi),256);
[mag_c1,ph_c1] = bode(c1,w_c);

plot(ax311,w_c/2/pi,20*log10(squeeze(mag_c1)));
plot(ax312,w_c/2/pi,squeeze(ph_c1));

xlabel(ax312,'Frequency (Hz)');
ylabel(ax311,'Gain (dB)');
ylabel(ax312,'Phase (deg)');

H31 = {'f','gc1','pc1'};
M31 = [w_c/2/pi; 20*log10(squeeze(mag_c1)).'; squeeze(ph_c1).'];

fid31 = fopen(fig31_name,'w');
fprintf(fid31,'%s,%s,%s\n',H31{:});  % must match number of columns
fprintf(fid31,'%6e,%6e,%6e\n',M31);
fclose(fid31);

% eof
