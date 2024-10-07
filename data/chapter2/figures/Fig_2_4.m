% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.4

% emtranpma1.mat: change in torque 0.01 at gen. 1, -0.01 at gen. 2 (figs. 2, 4)

clear all; close all; clc;                    % reset workspace
load('../mat/emtranpma1.mat');

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

%-------------------------------------%
% fig 4

fig4_name = './csv/ch2_fig4.csv';

fig4 = figure;
ax41 = subplot(1,1,1,'parent',fig4);
plot(ax41, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax41,'Time (s)');
ylabel(ax41,'Voltage magnitude (pu)');

legend(ax41,{'bus3','bus13'},'location','best');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';          % downsampling

H4 = {'t','c1','c2'};
M4 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s\n',H4{:});
fprintf(fid4,'%6e,%6e,%6e\n',M4);
fclose(fid4);

% eof
