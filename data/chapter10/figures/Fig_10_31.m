% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.31

% d2atcscs.mat: 2-area test case dc exciters and tcsc control

clear all; close all; clc;
load('../mat/d2atcscs.mat');
load('../mat/control6.mat');                  % tcsc control

%-------------------------------------%
% fig 31

fig31_name = './csv/ch10_fig31.csv';

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

sys_tcsc = ss(a_mat,b_tcsc(:,1),c_v(12,:),0);
[sys_tcsc_red,~] = balred(sys_tcsc,8);        % remove negligible states

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

plot(ax311,w_s/2/pi,20*log10(squeeze(mag_resid)), ...
           w_s/2/pi,20*log10(squeeze(mag_robust)));
plot(ax312,w_s/2/pi,squeeze(wrapTo180(ph_resid)), ...
           w_s/2/pi,squeeze(wrapTo180(ph_robust)));

xlabel(ax312,'Frequency (Hz)');
ylabel(ax311,'Gain (dB)');
ylabel(ax312,'Phase (deg)');

legend(ax311,{'residue control','robust control'},'location','northeast');
legend(ax312,{'residue control','robust control'},'location','southeast');

H31 = {'f','gc1','pc1','gc2','pc2'};
M31 = [w_s/2/pi; 20*log10(squeeze(mag_resid)).'; squeeze(wrapTo180(ph_resid)).'; ...
                 20*log10(squeeze(mag_robust)).'; squeeze(wrapTo180(ph_robust)).'];

fid31 = fopen(fig31_name,'w');
fprintf(fid31,'%s,%s,%s,%s,%s\n',H31{:});
fprintf(fid31,'%6e,%6e,%6e,%6e,%6e\n',M31);
fclose(fid31);

% eof
