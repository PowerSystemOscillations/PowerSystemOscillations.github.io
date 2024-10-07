% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.13

% sbtranpma2.mat: change in torque 0.01 at gen. 3, -0.01 at gen. 4 (figs. 12, 13)

clear all; close all; clc;
load('../mat/sbtranpma2.mat');

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

%-------------------------------------%
% fig 13

fig13_name = './csv/ch2_fig13.csv';

fig13 = figure;
ax131 = subplot(1,1,1,'parent',fig13);
plot(ax131, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax131,'Time (s)');
ylabel(ax131,'Voltage magnitude (pu)');

legend(ax131,{'bus3','bus13'},'location','best');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';          % downsampling

H13 = {'t','c1','c2'};
M13 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid13 = fopen(fig13_name,'w');
fprintf(fid13,'%s,%s,%s\n',H13{:});
fprintf(fid13,'%6e,%6e,%6e\n',M13);
fclose(fid13);

% eof
