% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.5

% emtranpma2.mat: change in torque 0.01 at gen. 3, -0.01 at gen. 4 (figs. 3, 5)

clear all; close all; clc;
load('../mat/emtranpma2.mat');

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

%-------------------------------------%
% fig 5

fig5_name = './csv/ch2_fig5.csv';

fig5 = figure;
ax51 = subplot(1,1,1,'parent',fig5);
plot(ax51, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax51,'Time (s)');
ylabel(ax51,'Voltage magnitude (pu)');
v = axis(ax51);
axis(ax51,[v(1), v(2), 0.982, 0.989]);

legend(ax51,{'bus3','bus13'},'location','best');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';          % downsampling

H5 = {'t','c1','c2'};
M5 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e\n',M5);
fclose(fid5);

% eof
