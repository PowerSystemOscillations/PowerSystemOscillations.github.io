%% fig 10.47

clear all; close all; clc;
load('d2aphvdcss.mat');
load('dcpf1cont2.mat');

Fs = 30;                       % sample rate
tt = 0:1/Fs:10;                % time vector for downsampling

fig47_name = './dat/ch10_fig47.dat';

fig47 = figure;
ax471 = subplot(1,1,1,'parent',fig47);
hold(ax471,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),(c_ang(3,:)-c_ang(9,:)),(d_angdcr(3,:)-d_angdcr(9,:)));
rate = 2*pi*60*tf([1 0],(2*pi*60)*[0.01 1]);
c1_n = conv([1,0],conv([0.1,1],[0.1,1]));
c1_d = conv([1,1],conv([0.02,1],[0.02,1]));
sys_c1 = tf(c1_n,c1_d);

sys_dcr_c1 = feedback(sys_dcr*rate,2*sys_c1,1,1,-1);

s_cr = ss(s_cr.a,s_cr.b,s_cr.c,s_cr.d);
sys_dcr_rc = feedback(sys_dcr*rate,s_cr,1,1,1);

%----------------------------------------%
% residue-based control (K=2)

ts = 0:0.001:10;
[y1,t1] = step(sys_dcr_c1,ts);
plot(ax471,t1,y1);

%----------------------------------------%
% robust control (K=1)

[y2,t2] = step(sys_dcr_rc,ts);
plot(ax471,t2,y2);
legend(ax471,{'residue control','robust control'},'location','best');

ylabel(ax471,'Frequency difference (pu)');
xlabel(ax471,'Time (s)');

y_v_dec = interp1(t1,[y1,y2],tt).';  % downsampling

%%
H47 = {'t','y1c1','y2c1','y1c2','y2c2'};
M47 = [tt; y_v_dec];
% 
fid47 = fopen(fig47_name,'w');
fprintf(fid47,'%s,%s,%s,%s,%s\n',H47{:});    % must match number of columns
fprintf(fid47,'%6e,%6e,%6e,%6e,%6e\n',M47);  % must match number of columns
fclose(fid47);

% eof
