% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.8

% emtranpma21: change in torque -0.01 at gen. 1, 0.01 at gen. 3 (figs. 8, 9)

clear all; close all; clc;
load('../mat/emtranpma21.mat');

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 8

fig8_name = './csv/ch2_fig8.csv';

fig8 = figure;
ax81 = subplot(2,1,1,'parent',fig8);
ax82 = subplot(2,1,2,'parent',fig8);
hold(ax81,'on');
hold(ax82,'on');
plot(ax81, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax81, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax82, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax82, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax82,'Time (s)');
ylabel(ax81,'Speed deviation (pu)');
ylabel(ax82,'Speed deviation (pu)');

% ingraph legend
legend(ax81,{'gen1','gen2'},'location','best');
legend(ax82,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';            % downsampling

H8 = {'t','c1','c2','c3','c4'};
M8 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
          mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid8 = fopen(fig8_name,'w');
fprintf(fid8,'%s,%s,%s,%s,%s\n',H8{:});
fprintf(fid8,'%6e,%6e,%6e,%6e,%6e\n',M8);
fclose(fid8);

% eof
