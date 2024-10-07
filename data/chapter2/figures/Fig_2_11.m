% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.11

% sbtranpma1.mat: change in torque 0.01 at gen. 1, -0.01 at gen. 2 (figs. 10, 11)

clear all; close all; clc;
load('../mat/sbtranpma1.mat');

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

%-------------------------------------%
% fig 11

fig11_name = './csv/ch2_fig11.csv';

fig11 = figure;
ax111 = subplot(1,1,1,'parent',fig11);
plot(ax111, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax111,'Time (s)');
ylabel(ax111,'Voltage magnitude (pu)');

legend(ax111,{'bus3','bus13'},'location','best');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';          % downsampling

H11 = {'t','c1','c2'};
M11 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid11 = fopen(fig11_name,'w');
fprintf(fid11,'%s,%s,%s\n',H11{:});
fprintf(fid11,'%6e,%6e,%6e\n',M11);
fclose(fid11);

% eof
