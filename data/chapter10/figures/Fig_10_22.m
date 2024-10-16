% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.22

% d2adcem2rc2.mat: 2-area test case, one line 13--101, robust control 2

clear all; close all; clc;
load('../mat/d2adcem2rc2.mat');

%-------------------------------------%
% fig 22

Fs = 30;                                      % sample rate
tt = 0:1/Fs:10;                               % time vector

fig22_name = './csv/ch10_fig22.csv';

fig22 = figure;
ax221 = subplot(1,1,1,'parent',fig22);
hold(ax221,'on');

plot(ax221,t,abs(bus_v([3 8],:)));
legend(ax221,{'bus 3','bus 13'},'location','southeast');

ylabel(ax221,'Voltage magnitude (pu)');
xlabel(ax221,'Time (s)');

% downsampling
bus_v_dec = interp1(t,abs(bus_v([3 8],:)).',tt).';

H22 = {'t','v3','v13'};
M22 = [tt; bus_v_dec];

fid22 = fopen(fig22_name,'w');
fprintf(fid22,'%s,%s,%s\n',H22{:});
fprintf(fid22,'%6e,%6e,%6e\n',M22);
fclose(fid22);

% eof
