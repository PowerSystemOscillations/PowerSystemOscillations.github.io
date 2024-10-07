% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.10

% sbtranpma1.mat: change in torque 0.01 at gen. 1, -0.01 at gen. 2 (figs. 10, 11)

clear all; close all; clc;
load('../mat/sbtranpma1.mat');

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

%-------------------------------------%
% fig 10

fig10_name = './csv/ch2_fig10.csv';

fig10 = figure;
ax101 = subplot(2,1,1,'parent',fig10);
ax102 = subplot(2,1,2,'parent',fig10);
hold(ax101,'on');
hold(ax102,'on');
plot(ax101, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax101, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax102, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax102, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax102,'Time (s)');
ylabel(ax101,'Speed deviation (pu)');
ylabel(ax102,'Speed deviation (pu)');

% ingraph legend
legend(ax101,{'gen1','gen2'},'location','best');
legend(ax102,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling

H10 = {'t','c1','c2','c3','c4'};
M10 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
           mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid10 = fopen(fig10_name,'w');
fprintf(fid10,'%s,%s,%s,%s,%s\n',H10{:});
fprintf(fid10,'%6e,%6e,%6e,%6e,%6e\n',M10);
fclose(fid10);

% eof
