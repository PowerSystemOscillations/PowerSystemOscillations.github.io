% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.9

% emtranpma21: change in torque -0.01 at gen. 1, 0.01 at gen. 3 (figs. 8, 9)

clear all; close all; clc;
load('../mat/emtranpma21.mat');

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 9

fig9_name = './csv/ch2_fig9.csv';

fig9 = figure;
ax91 = subplot(1,1,1,'parent',fig9);
plot(ax91, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));
v = axis(ax91);
axis(ax91,[v(1),v(2),0.977,0.994]);

xlabel(ax91,'Time (s)');
ylabel(ax91,'Voltage magnitude (pu)');

legend(ax91,{'bus3','bus13'},'location','best');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';  % downsampling

H9 = {'t','c1','c2'};
M9 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
