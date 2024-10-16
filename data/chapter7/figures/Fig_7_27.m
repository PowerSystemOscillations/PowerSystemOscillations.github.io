% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.27

% 16m2tseptran.mat: 16-machine system, PSSs on all generators, simulation

clear all; close all; clc;
load('../mat/16m2tseptran.mat');

%-------------------------------------%
% fig 27

Fs = 20;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig27_name = './csv/ch7_fig27.csv';

fig27 = figure;
ax27 = subplot(1,1,1,'parent',fig27);
hold(ax27,'on');

plot(ax27, t, mac_spd);

ylabel(ax27,'Speed (pu)');
xlabel(ax27,'Time (s)');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling

H27 = {'t','spd'};
M27 = [tt; mac_spd_dec];

fid27 = fopen(fig27_name,'w');
fprintf(fid27,'%s,%s\n',H27{:});
fprintf(fid27,'%6e,%6e\n',M27);
fclose(fid27);

% eof
