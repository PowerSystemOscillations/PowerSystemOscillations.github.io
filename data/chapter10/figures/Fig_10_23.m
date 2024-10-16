% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.23

% d2adcem2rc1.mat: 2-area test case, one line 13--101, robust control 1
% d2adcem2rc2.mat: 2-area test case, one line 13--101, robust control 2

clear all; close all; clc;
load('../mat/d2adcem2rc1.mat');

%-------------------------------------%
% fig 23

Fs = 30;                                      % sample rate
tt = 0:1/Fs:10;                               % time vector

fig23_name = './csv/ch10_fig23.csv';

fig23 = figure;
ax231 = subplot(2,1,1,'parent',fig23);
ax232 = subplot(2,1,2,'parent',fig23);
hold(ax231,'on');
hold(ax232,'on');

% robust control 1

svc_ilf1 = svc_ilf;
svc_dsig1 = svc_dsig;

plot(ax231,t,abs(svc_ilf));
v = axis(ax231);
axis(ax231,[0,5,v(3),7]);

plot(ax232,t,svc_dsig);

% robust control 2

load('../mat/d2adcem2rc2.mat');

svc_ilf2 = svc_ilf;
svc_dsig2 = svc_dsig;

plot(ax231,t,abs(svc_ilf));
v = axis(ax231);
axis(ax231,[0,5,v(3),7]);

plot(ax232,t,svc_dsig);

ylabel(ax231,'Current mag. (pu)');
ylabel(ax232,'Control output (pu)');
xlabel(ax232,'Time (s)');

v = axis(ax232);
axis(ax232,[0,5,-0.125,0.125]);

legend(ax231,{'robust control 1','robust control 2'},'location','best');
legend(ax232,{'robust control 1','robust control 2'},'location','best');

curr_mag_dec1 = interp1(t,abs(svc_ilf1),tt);
svc_dsig_dec1 = interp1(t,svc_dsig1,tt);

curr_mag_dec2 = interp1(t,abs(svc_ilf2),tt);
svc_dsig_dec2 = interp1(t,svc_dsig2,tt);

H23 = {'t','cm1','sd1','cm2','sd2'};
M23 = [tt; curr_mag_dec1; svc_dsig_dec1; ...
           curr_mag_dec2; svc_dsig_dec2];

fid23 = fopen(fig23_name,'w');
fprintf(fid23,'%s,%s,%s,%s,%s\n',H23{:});
fprintf(fid23,'%6e,%6e,%6e,%6e,%6e\n',M23);
fclose(fid23);

% eof
