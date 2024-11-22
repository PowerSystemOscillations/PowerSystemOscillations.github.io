% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.21

% d2adcem2rc2.mat: 2-area system with dc exciters, one line 13--101,
%                  robust control 2 (state space)

clear all; close all; clc;
load('../mat/d2adcem2rc2.mat');

%-------------------------------------%
% fig 21

Fs = 30;                                      % sample rate
tt = 0:1/Fs:10;                               % time vector

fig21_name = './csv/ch10_fig21.csv';

fig21 = figure;
ax211 = subplot(2,1,1,'parent',fig21);
ax212 = subplot(2,1,2,'parent',fig21);
%
hold(ax211,'on');
hold(ax212,'on');

plot(ax211,t,mac_ang([1 2],:));
legend(ax211,{'gen 1','gen 2'},'location','southeast');

plot(ax212,t,mac_ang([3 4],:));
legend(ax212,{'gen 3','gen 4'},'location','southeast');

ylabel(ax211,'Rotor angle (rad.)');
ylabel(ax212,'Rotor angle (rad.)');
xlabel(ax212,'Time (s)');

mac_ang_dec = interp1(t,mac_ang.',tt).';      % downsampling

H21 = {'t','a1','a2','a3','a4'};
M21 = [tt; mac_ang_dec];

fid21 = fopen(fig21_name,'w');
fprintf(fid21,'%s,%s,%s,%s,%s\n',H21{:});
fprintf(fid21,'%6e,%6e,%6e,%6e,%6e\n',M21);
fclose(fid21);

% eof
