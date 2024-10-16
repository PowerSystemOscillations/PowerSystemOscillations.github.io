%% fig 10.36

clear all; close all; clc;
load('d2atcscs.mat');
load('control6.mat');

fig36_name = './dat/ch10_fig36.dat';

fig36 = figure;
ax361 = subplot(1,1,1,'parent',fig36);
hold(ax361,'on');

sys_tcsc = ss(a_mat,[b_tcsc(:,1),b_lmod],[c_v(12,:);c_v([3 8],:);c_ang([3 8],:)],0);

sc3 = ss(sc3.a,sc3.b,sc3.c,sc3.d);
scr = ss(scr.a,scr.b,scr.c,scr.d);
sys_rc = 100*sc3*scr;

sys_tcsc_rc = feedback(sys_tcsc,sys_rc,1,1,1);

%----------------------------------------%
% robust control 1

W_sv = logspace(-2,log10(100*2*pi),256);
G_m = ss(sys_tcsc_rc.a,0.1*sys_tcsc_rc.b(:,[2,3]),20*sys_tcsc_rc.c([2,3],:),0);
SV_m = sigma(G_m,W_sv);

% l_mod to tie bus V_m and bus frequency
G_a = ss(sys_tcsc_rc.a,0.1*sys_tcsc_rc.b(:,[2,3]),sys_tcsc_rc.c([4,5],:),0);

% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_f = 1000*[rate 0; 0 rate]*G_a;
SV_f = sigma(G_f,W_sv);

plot(ax361,W_sv/(2*pi),SV_m(1,:),W_sv/(2*pi),SV_f(1,:));
set(ax361,'xscale','log','yscale','log');

legend(ax361,{'bus voltage','bus frequency'},'location','northeast');

axis(ax361,[1e-2 100 1e-3 1]);
xlabel('Frequency (Hz)');
% 
H36 = {'f_sv','SV_m','SV_f'};
M36 = [W_sv/2/pi; SV_m(1,:); SV_f(1,:)];
%
fid36 = fopen(fig36_name,'w');
fprintf(fid36,'%s,%s,%s\n',H36{:});  % must match number of columns
fprintf(fid36,'%6e,%6e,%6e\n',M36);  % must match number of columns
fclose(fid36);

% eof
