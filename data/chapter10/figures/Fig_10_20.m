% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.20

% d2adcem2rc1.mat: 2-area test case, one line 13--101, robust control 1

clear all; close all; clc;
load('../mat/d2adcem2rc1.mat');

%-------------------------------------%
% fig 20

Fs = 30;                                      % sample rate
tt = 0:1/Fs:10;                               % time vector

fig20_name = './csv/ch10_fig20.csv';

fig20 = figure;
ax201 = subplot(2,1,1,'parent',fig20);
ax202 = subplot(2,1,2,'parent',fig20);
%
hold(ax201,'on');
hold(ax202,'on');

plot(ax201,t,mac_ang([1 2],:));
legend(ax201,{'gen 1','gen 2'},'location','southeast');

plot(ax202,t,mac_ang([3 4],:));
legend(ax202,{'gen 3','gen 4'},'location','northeast');

ylabel(ax201,'Rotor angle (rad.)');
ylabel(ax202,'Rotor angle (rad.)');
xlabel(ax202,'Time (s)');

mac_ang_dec = interp1(t,mac_ang.',tt).';      % downsampling

H20 = {'t','a1','a2','a3','a4'};
M20 = [tt; mac_ang_dec];

fid20 = fopen(fig20_name,'w');
fprintf(fid20,'%s,%s,%s,%s,%s\n',H20{:});
fprintf(fid20,'%6e,%6e,%6e,%6e,%6e\n',M20);
fclose(fid20);

% eof
