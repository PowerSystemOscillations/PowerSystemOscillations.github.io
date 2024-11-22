% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.45

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');
load('../mat/dcpf1cont2.mat');                % damping control

%-------------------------------------%
% fig 45

Fs = 30;                                      % sample rate
tt = 0:1/Fs:10;                               % time vector

fig45_name = './csv/ch10_fig45.csv';

fig45 = figure;
ax451 = subplot(1,1,1,'parent',fig45);
hold(ax451,'on');

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
y1 = y1/(2*pi*60);
plot(ax451,t1,60e3*y1);

%----------------------------------------%
% robust control (K=1)

[y2,t2] = step(sys_dcr_rc,ts);
y2 = y2/(2*pi*60);
plot(ax451,t2,60e3*y2);
legend(ax451,{'residue control','robust control'},'location','best');

ylabel(ax451,'Frequency difference (mHz)');
xlabel(ax451,'Time (s)');

% exporting data

y_v_dec = interp1(t1,[y1,y2],tt).';           % downsampling

H45 = {'t','y1c1','y2c1','y1c2','y2c2'};
M45 = [tt; y_v_dec];

fid45 = fopen(fig45_name,'w');
fprintf(fid45,'%s,%s,%s,%s,%s\n',H45{:});
fprintf(fid45,'%6e,%6e,%6e,%6e,%6e\n',M45);
fclose(fid45);

% eof
