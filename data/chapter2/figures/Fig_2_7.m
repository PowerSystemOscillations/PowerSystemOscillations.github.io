% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.7

% emtranpma12: change in torque 0.01 at gen. 1, -0.01 at gen. 3 (figs. 6, 7)

clear all; close all; clc;
load('../mat/emtranpma12.mat');

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 7

fig7_name = './csv/ch2_fig7.csv';

fig7 = figure;
ax71 = subplot(1,1,1,'parent',fig7);
plot(ax71, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax71,'Time (s)');
ylabel(ax71,'Voltage (pu)');
v = axis(ax71);
axis(ax71,[v(1),v(2),0.977,0.994]);

legend(ax71,{'bus3','bus13'},'location','best');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';  % downsampling

H7 = {'t','c1','c2'};
M7 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid7 = fopen(fig7_name,'w');
fprintf(fid7,'%s,%s,%s\n',H7{:});
fprintf(fid7,'%6e,%6e,%6e\n',M7);
fclose(fid7);

% eof
