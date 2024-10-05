% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.18

% sbegtranpr1_10s: step change of 0.01 in Pmech of generator 1 (fig. 18)

clear all; close all; clc;
load('../mat/sbegtranpr1.mat');

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 18

fig18_name = './csv/ch2_fig18.csv';

fig18 = figure;
ax181 = subplot(2,1,1,'parent',fig18);
ax182 = subplot(2,1,2,'parent',fig18);
hold(ax181,'on');
hold(ax182,'on');
plot(ax181, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax181, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax182, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax182, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax182,'Time (s)');
ylabel(ax181,'Speed change (pu)');
ylabel(ax182,'Speed change (pu)');

% ingraph legend
legend(ax181,{'gen1','gen2'},'location','best');
legend(ax182,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';            % downsampling

H18 = {'t','c1','c2','c3','c4'};
M18 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
          mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid18 = fopen(fig18_name,'w');
fprintf(fid18,'%s,%s,%s,%s,%s\n',H18{:});
fprintf(fid18,'%6e,%6e,%6e,%6e,%6e\n',M18);
fclose(fid18);

% eof
