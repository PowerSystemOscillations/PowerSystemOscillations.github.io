%% fig 10.52

clear all; close all; clc;
load('d2aphvdcss.mat');
load('dcpf1cont2.mat');

fig52_name = './dat/ch10_fig52.dat';

fig52 = figure;
ax521 = subplot(2,1,1,'parent',fig52);
ax522 = subplot(2,1,2,'parent',fig52);
%
hold(ax521,'on');
hold(ax522,'on');

d_dcr = [[(d_angdcr(3,:)-d_angdcr(9,:)); 0; 0; d_angdcr(3,:); d_angdcr(9,:)], zeros(5,2)];
sys_dcr = ss(a_mat,[b_dcr(:,1),b_lmod], ...
             [c_ang(3,:)-c_ang(9,:);c_v([3 9],:);c_ang([3 9],:)],d_dcr);
rate = 2*pi*60*tf([1 0],(2*pi*60)*[0.01 1]);
sys_wo = tf([0.1,0],[0.1,1]);
s_crmp = ss(s_crmp.a,s_crmp.b,s_crmp.c,s_crmp.d);

sys_dcr_rc = feedback(sys_dcr,3*rate*sys_wo*s_crmp,1,1,-1);

%----------------------------------------%
% open loop

W_sv = logspace(-2,log10(100*2*pi),256);
G_m1 = ss(sys_dcr.a,0.1*sys_dcr.b(:,[2,3]),20*sys_dcr.c([2,3],:),0);
SV_m1 = sigma(G_m1,W_sv);

% l_mod to tie bus V_m and bus frequency
G_a1 = ss(sys_dcr.a,0.1*sys_dcr.b(:,[2,3]),sys_dcr.c([4,5],:),0);

% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_f1 = 1000*[rate 0; 0 rate]*G_a1;
SV_f1 = sigma(G_f1,W_sv);

%----------------------------------------%
% minimum-phase robust control (K=3)

W_sv = logspace(-2,log10(100*2*pi),256);
G_m2 = ss(sys_dcr_rc.a,0.1*sys_dcr_rc.b(:,[2,3]),20*sys_dcr_rc.c([2,3],:),0);
SV_m2 = sigma(G_m2,W_sv);

% l_mod to tie bus V_m and bus frequency
G_a2 = ss(sys_dcr_rc.a,0.1*sys_dcr_rc.b(:,[2,3]),sys_dcr_rc.c([4,5],:),0);

% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_f2 = 1000*[rate 0; 0 rate]*G_a2;
SV_f2 = sigma(G_f2,W_sv);

plot(ax521,W_sv/(2*pi),SV_m1(1,:),W_sv/(2*pi),SV_m2(1,:));
set(ax521,'xscale','log','yscale','log');

plot(ax522,W_sv/(2*pi),SV_f1(1,:),W_sv/(2*pi),SV_f2(1,:));
set(ax522,'xscale','log','yscale','log');

legend(ax521,{'open loop','minimum-phase'},'location','northeast');
legend(ax522,{'open loop','minimum-phase'},'location','northeast');
axis(ax521,[1e-2 100 1e-3 1]);
axis(ax522,[1e-2 100 1e-2 1]);
xlabel('Frequency (Hz)');
% 
H52 = {'f_sv','SV_m1','SV_m2','SV_f1','SV_f2'};
M52 = [W_sv/2/pi; SV_m1(1,:); SV_m2(1,:); SV_f1(1,:); SV_f2(1,:)];
% 
fid52 = fopen(fig52_name,'w');
fprintf(fid52,'%s,%s,%s,%s,%s\n',H52{:});    % must match number of columns
fprintf(fid52,'%6e,%6e,%6e,%6e,%6e\n',M52);  % must match number of columns
fclose(fid52);

% eof
