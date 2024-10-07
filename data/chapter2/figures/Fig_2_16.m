% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.16

% sbegtranpma1: change in torque 0.01 at gen. 1, -0.01 at gen. 2 (figs. 16, 17)

clear all; close all; clc;
load('../mat/sbegtranpma1.mat');

Fs = 60;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

%-------------------------------------%
% fig 16

fig16_name = './csv/ch2_fig16.csv';

fig16 = figure;
ax161 = subplot(2,1,1,'parent',fig16);
ax162 = subplot(2,1,2,'parent',fig16);
hold(ax161,'on');
hold(ax162,'on');
plot(ax161, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax161, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax162, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax162, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax162,'Time (s)');
ylabel(ax161,'Speed deviation (pu)');
ylabel(ax162,'Speed deviation (pu)');
v = axis(ax162);
axis(ax162,[v(1),v(2),-0.105e-3,0.105e-3]);

% ingraph legend
legend(ax161,{'gen1','gen2'},'location','best');
legend(ax162,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling

H16 = {'t','c1','c2','c3','c4'};
M16 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
          mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid16 = fopen(fig16_name,'w');
fprintf(fid16,'%s,%s,%s,%s,%s\n',H16{:});
fprintf(fid16,'%6e,%6e,%6e,%6e,%6e\n',M16);
fclose(fid16);

% eof
