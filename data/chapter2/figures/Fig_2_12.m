% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.12

% sbtranpma2: change in torque 0.01 at gen. 3, -0.01 at gen. 4 (figs. 12, 13)

clear all; close all; clc;
load('../mat/sbtranpma2.mat');

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 12

fig12_name = './csv/ch2_fig12.csv';

fig12 = figure;
ax121 = subplot(2,1,1,'parent',fig12);
ax122 = subplot(2,1,2,'parent',fig12);
hold(ax121,'on');
hold(ax122,'on');
plot(ax121, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax121, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax122, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax122, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax122,'Time (s)');
ylabel(ax121,'Speed deviation (pu)');
ylabel(ax122,'Speed deviation (pu)');

% ingraph legend
legend(ax121,{'gen1','gen2'},'location','best');
legend(ax122,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';            % downsampling

H12 = {'t','c1','c2','c3','c4'};
M12 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
          mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid12 = fopen(fig12_name,'w');
fprintf(fid12,'%s,%s,%s,%s,%s\n',H12{:});
fprintf(fid12,'%6e,%6e,%6e,%6e,%6e\n',M12);
fclose(fid12);

% eof
