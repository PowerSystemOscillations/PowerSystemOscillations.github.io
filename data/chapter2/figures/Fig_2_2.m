% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.2

% emtranpma1: change in torque 0.01 at gen. 1, -0.01 at gen. 2 (figs. 2, 4)

clear all; close all; clc;     % reset workspace
load('../mat/emtranpma1.mat');

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 2

fig2_name = './csv/ch2_fig2.csv';                   % data file

fig2 = figure;                                      % create figure table
ax21 = subplot(2,1,1,'parent',fig2);
ax22 = subplot(2,1,2,'parent',fig2);
hold(ax21,'on');                                    % always on for axis objects
hold(ax22,'on');
plot(ax21, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax21, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax22, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax22, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax22,'Time (s)');
ylabel(ax21,'Speed deviation (pu)');
ylabel(ax22,'Speed deviation (pu)');

% ingraph legend
legend(ax21,{'gen1','gen2'},'location','best');
legend(ax22,{'gen3','gen4'},'location','best');

% exporting data file
mac_spd_dec = interp1(t,mac_spd.',tt).';            % downsampling

H2 = {'t','c1','c2','c3','c4'};
M2 = [tt; mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
          mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid2 = fopen(fig2_name,'w');
fprintf(fid2,'%s,%s,%s,%s,%s\n',H2{:});             % must match number of columns
fprintf(fid2,'%6e,%6e,%6e,%6e,%6e\n',M2);
fclose(fid2);

% eof
