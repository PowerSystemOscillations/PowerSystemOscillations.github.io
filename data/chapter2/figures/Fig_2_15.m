% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.5

% sbtranpma12: change in torque 0.01 at gen. 1, -0.01 at gen. 3 (figs. 14, 15)

clear all; close all; clc;
load('../mat/sbtranpm12.mat');

Fs = 60;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 15

fig15_name = './csv/ch2_fig15.csv';

fig15 = figure;
ax151 = subplot(1,1,1,'parent',fig15);
plot(ax151, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax151,'Time (s)');
ylabel(ax151,'Voltage magnitude (pu)');

legend(ax151,{'bus3','bus13'},'location','best');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt,'spline').';  % downsampling

H15 = {'t','c1','c2'};
M15 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid15 = fopen(fig15_name,'w');
fprintf(fid15,'%s,%s,%s\n',H15{:});
fprintf(fid15,'%6e,%6e,%6e\n',M15);
fclose(fid15);

% eof
