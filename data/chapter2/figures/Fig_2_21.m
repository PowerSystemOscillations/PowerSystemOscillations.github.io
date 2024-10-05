% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.21

% emtran3pf: three-phase fault at bus 3, (fig. 21)

clear all; close all; clc;
load('../mat/emtran3pf.mat');

Fs = 60;                        % sample rate
tt = [t(1:39),0.2:1/Fs:t(end)]; % time vector with constant step size

%-------------------------------------%
% fig 21

fig21_name = './csv/ch2_fig21.csv';

fig21 = figure;
ax211 = subplot(1,1,1,'parent',fig21);
plot(ax211, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax211,'Time (s)');
ylabel(ax211,'Voltage (pu)');

legend(ax211,{'bus3','bus13'},'location','northeast');

%exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';  % downsampling

H21 = {'t','c1','c2'};
M21 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid21 = fopen(fig21_name,'w');
fprintf(fid21,'%s,%s,%s\n',H21{:});
fprintf(fid21,'%6e,%6e,%6e\n',M21);
fclose(fid21);

% eof
