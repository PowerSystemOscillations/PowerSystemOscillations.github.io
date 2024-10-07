% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.23

% sbegtran3pf.mat: three-phase fault at bus 3, (fig. 23)

clear all; close all; clc;
load('../mat/sbegtran3pf.mat');

Fs = 60;                                      % sample rate
tt = [t(1:19),0.2:1/Fs:t(end)];               % time vector

%-------------------------------------%
% fig 23

fig23_name = './csv/ch2_fig23.csv';

fig23 = figure;
ax231 = subplot(1,1,1,'parent',fig23);
plot(ax231, t, abs(bus_v(3,:)), t, abs(bus_v(8,:)));

xlabel(ax231,'Time (s)');
ylabel(ax231,'Voltage (pu)');

legend(ax231,{'bus3','bus13'},'location','northeast');

% exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';          % downsampling

H23 = {'t','c1','c2'};
M23 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid23 = fopen(fig23_name,'w');
fprintf(fid23,'%s,%s,%s\n',H23{:});
fprintf(fid23,'%6e,%6e,%6e\n',M23);
fclose(fid23);

% eof
