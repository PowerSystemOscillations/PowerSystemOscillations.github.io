% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.2

% emtranpma2.mat: change in torque 0.01 at gen. 3, -0.01 at gen. 4 (figs. 3, 5)

clear all; close all; clc;
load('../mat/emtranpma2.mat');

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

%-------------------------------------%
% fig 3

fig3_name = './csv/ch2_fig3.csv';

fig3 = figure;
ax31 = subplot(2,1,1,'parent',fig3);
ax32 = subplot(2,1,2,'parent',fig3);
hold(ax31,'on');
hold(ax32,'on');
plot(ax31, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax31, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax32, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax32, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax32,'Time (s)');
ylabel(ax31,'Speed deviation (pu)');
ylabel(ax32,'Speed deviation (pu)');

% ingraph legend
legend(ax31,{'gen1','gen2'},'location','best');
legend(ax32,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling

H3 = {'t','c1','c2','c3','c4'};
M3 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
          mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid3 = fopen(fig3_name,'w');
fprintf(fid3,'%s,%s,%s,%s,%s\n',H3{:});
fprintf(fid3,'%6e,%6e,%6e,%6e,%6e\n',M3);
fclose(fid3);

% eof
