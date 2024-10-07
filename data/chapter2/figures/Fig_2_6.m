% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.6

% emtranpma12.mat: change in torque 0.01 at gen. 1, -0.01 at gen. 3 (figs. 6, 7)

clear all; close all; clc;
load('../mat/emtranpma12.mat');

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

%-------------------------------------%
%fig 6

fig6_name = './csv/ch2_fig6.csv';

fig6 = figure;
ax61 = subplot(2,1,1,'parent',fig6);
ax62 = subplot(2,1,2,'parent',fig6);
hold(ax61,'on');
hold(ax62,'on');
plot(ax61, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax61, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax62, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax62, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax62,'Time (s)');
ylabel(ax61,'Speed deviation (pu)');
ylabel(ax62,'Speed deviation (pu)');

% ingraph legend
legend(ax61,{'gen1','gen2'},'location','best');
legend(ax62,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling

H6 = {'t','c1','c2','c3','c4'};
M6 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
          mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid6 = fopen(fig6_name,'w');
fprintf(fid6,'%s,%s,%s,%s,%s\n',H6{:});
fprintf(fid6,'%6e,%6e,%6e,%6e,%6e\n',M6);
fclose(fid6);

% eof
