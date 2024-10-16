%% fig 10.51

clear all; close all; clc;
load('d2aphvdcss.mat');
load('dcpf1cont2.mat');

fig51_name = './dat/ch10_fig51.dat';

fig51 = figure;
ax511 = subplot(1,1,1,'parent',fig51);
hold(ax511,'on');
grid(ax511,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:)-c_ang(9,:),d_angdcr(3,:)-d_angdcr(9,:));
rate = 2*pi*60*tf([1 0],(2*pi*60)*[0.01 1]);
sys_wo = tf([0.1,0],[0.1,1]);
s_crmp = ss(s_crmp.a,s_crmp.b,s_crmp.c,s_crmp.d);

% sys_dcr_rc = feedback(sys_dcr,3*rate*sys_wo*s_crmp,1,1,-1);
sys_dcr_rc = feedback(sys_dcr,3*rate*sys_wo*s_crmp,1,1,-1);

[~,M,N] = lncf(sys_dcr_rc);
K = s_crmp;
G_rc = sys_dcr;
M_b = [K*(1 - G_rc*K)\inv(M); (1 - G_rc*K)\inv(M)];

%----------------------------------------%
% open loop

W_sv = logspace(-2,log10(100*2*pi),256);
G_m1 = ss(M_b.a,M_b.b,M_b.c,M_b.d);
SV_m1 = sigma(G_m1,W_sv);

% l_mod to tie bus V_m and bus frequency
% G_a1 = ss(sys_dcr.a,0.1*sys_dcr.b(:,[2,3]),sys_dcr.c([4,5],:),0);

% % add rate filter to obtain c_f
% rate = tf([1 0],(2*pi*60)*[0.01 1]);
% G_f1 = 1000*[rate 0; 0 rate]*G_a1;
% SV_f1 = sigma(G_f1,W_sv);

%----------------------------------------%
% minimum-phase robust control (K=3)

% W_sv = logspace(-2,log10(100*2*pi),256);
% G_m2 = ss(M.a,M.b,M.c,M.d);
% SV_m2 = sigma(G_m2,W_sv);

% l_mod to tie bus V_m and bus frequency
% G_a2 = ss(sys_dcr_rc.a,0.1*sys_dcr_rc.b(:,[2,3]),sys_dcr_rc.c([4,5],:),0);

% % add rate filter to obtain c_f
% rate = tf([1 0],(2*pi*60)*[0.01 1]);
% G_f2 = 1000*[rate 0; 0 rate]*G_a2;
% SV_f2 = sigma(G_f2,W_sv);

plot(ax511,W_sv/(2*pi),SV_m1(1,:));
set(ax511,'xscale','log','yscale','log');

% plot(ax512,W_sv/(2*pi),SV_f1(1,:),W_sv/(2*pi),SV_f2(1,:));
% set(ax512,'xscale','log','yscale','log');

legend(ax511,{'minimum phase','non-minimum phase'},'location','northeast');
axis(ax511,[1e-2 100 1e-1 1e1]);
xlabel(ax511,'Frequency (Hz)');
% 
% H51 = {'f_sv','SV_m1','SV_m1','SV_f1','SV_f2'};
% M51 = [W_sv/2/pi; SV_m1(1,:); SV_m2(1,:); SV_f1(1,:); SV_f2(1,:)];
% % 
% fid51 = fopen(fig51_name,'w');
% fprintf(fid51,'%s,%s,%s,%s,%s\n',H51{:});    % must match number of columns
% fprintf(fid51,'%6e,%6e,%6e,%6e,%6e\n',M51);  % must match number of columns
% fclose(fid51);

% eof
