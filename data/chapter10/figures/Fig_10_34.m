%% fig 10.34

clear all; close all; clc;
load('d2atcscs.mat');
load('control6.mat');

fig34_name = './dat/ch10_fig34.dat';

fig34 = figure;
ax341 = subplot(2,1,1,'parent',fig34);
ax342 = subplot(2,1,2,'parent',fig34);
%
hold(ax341,'on');
hold(ax342,'on');
%
set(ax341,'xscale','log');
set(ax342,'xscale','log');
%set(ax341,'yscale','log');

sys_tcsc = ss(a_mat,b_tcsc(:,1),c_v(12,:),0);
[sys_tcsc_red,~] = balred(sys_tcsc,8);  % remove negligible states

cn = 100*conv([1,0],conv([0.1,1],[0.1,1]));
cd = conv([1,1],conv([0.05,1],conv([0.5,1],[0.5,1])));
sys_c1 = tf(cn,cd);

sc3 = ss(sc3.a,sc3.b,sc3.c,sc3.d);
scr = ss(scr.a,scr.b,scr.c,scr.d);
sys_rc1 = 100*sc3*scr;

sys_tcsc_resid = sys_c1*sys_tcsc_red;
sys_tcsc_robust = sys_rc1*sys_tcsc_red;

% sys_sv3red_c1 = sys_c1*sys_sv3red;
% sys_sv3red_c2 = sys_c2*sys_sv3red;

w_s = [linspace(0.01,2,128),linspace(2.1,100,128)]*2*pi;
[mag_resid,ph_resid] = bode(sys_tcsc_resid,w_s);
[mag_robust,ph_robust] = bode(sys_tcsc_robust,w_s);

plot(ax341,w_s/2/pi,20*log10(squeeze(mag_resid)), ...
           w_s/2/pi,20*log10(squeeze(mag_robust)));
plot(ax342,w_s/2/pi,squeeze(wrapTo180(ph_resid)), ...
           w_s/2/pi,squeeze(wrapTo180(ph_robust)));

xlabel(ax342,'Frequency (Hz)');
ylabel(ax341,'Gain (dB)');
ylabel(ax342,'Phase (deg)');

legend(ax341,{'residue control','robust control'},'location','northeast');
legend(ax342,{'residue control','robust control'},'location','southeast');

H34 = {'f','gc1','pc1','gc2','pc2'};
M34 = [w_s/2/pi; 20*log10(squeeze(mag_resid)).'; squeeze(wrapTo180(ph_resid)).'; ...
                 20*log10(squeeze(mag_robust)).'; squeeze(wrapTo180(ph_robust)).'];

fid34 = fopen(fig34_name,'w');
fprintf(fid34,'%s,%s,%s,%s,%s\n',H34{:});    % must match number of columns
fprintf(fid34,'%6e,%6e,%6e,%6e,%6e\n',M34);  % must match number of columns
fclose(fid34);

% eof
