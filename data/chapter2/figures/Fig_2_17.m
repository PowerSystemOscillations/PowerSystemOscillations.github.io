% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.17

% sbegtranpma1: change in torque 0.01 at gen. 1, -0.01 at gen. 2 (figs. 16, 17)

clear all; close all; clc;
load('../mat/sbegtranpma1.mat');

Fs = 60;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 17

fig17_name = './csv/ch2_fig17.csv';

fig17 = figure;
ax171 = subplot(1,1,1,'parent',fig17);
plot(ax171, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax171,'Time (s)');
ylabel(ax171,'Voltage magnitude (pu)');
v = axis(ax171);
axis(ax171,[v(1),v(2),0.982,0.9885]);

legend(ax171,{'bus3','bus13'},'location','best');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';  % downsampling

H17 = {'t','c1','c2'};
M17 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid17 = fopen(fig17_name,'w');
fprintf(fid17,'%s,%s,%s\n',H17{:});
fprintf(fid17,'%6e,%6e,%6e\n',M17);
fclose(fid17);

% eof
