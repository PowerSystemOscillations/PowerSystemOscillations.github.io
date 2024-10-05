% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.14

% sbtranpma12: change in torque 0.01 at gen. 1, -0.01 at gen. 3 (figs. 14, 15)

clear all; close all; clc;
load('../mat/sbtranpm12.mat');

Fs = 60;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 14

fig14_name = './csv/ch2_fig14.csv';

fig14 = figure;
ax141 = subplot(2,1,1,'parent',fig14);
ax142 = subplot(2,1,2,'parent',fig14);
hold(ax141,'on');
hold(ax142,'on');
plot(ax141, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax141, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax142, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax142, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax142,'Time (s)');
ylabel(ax141,'Speed deviation (pu)');
ylabel(ax142,'Speed deviation (pu)');

% ingraph legend
legend(ax141,{'gen1','gen2'},'location','best');
legend(ax142,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';            % downsampling

H14 = {'t','c1','c2','c3','c4'};
M14 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
          mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid14 = fopen(fig14_name,'w');
fprintf(fid14,'%s,%s,%s,%s,%s\n',H14{:});
fprintf(fid14,'%6e,%6e,%6e,%6e,%6e\n',M14);
fclose(fid14);

% eof
