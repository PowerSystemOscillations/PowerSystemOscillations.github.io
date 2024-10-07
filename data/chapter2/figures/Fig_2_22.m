% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.22

% sbtran3pf.mat: three-phase fault at bus 3, (fig. 22)

clear all; close all; clc;
load('../mat/sbtran3pf.mat');

Fs = 60;                                      % sample rate
tt = [t(1:19),0.2:1/Fs:t(end)];               % time vector

%-------------------------------------%
%fig 22

fig22_name = './csv/ch2_fig22.csv';

fig22 = figure;
ax221 = subplot(1,1,1,'parent',fig22);
mask = abs(bus_v(8,:)) > 1e-3;
plot(ax221, t(mask), abs(bus_v(3,mask)), t(mask), abs(bus_v(8,mask)));

xlabel(ax221,'Time (s)');
ylabel(ax221,'Voltage (pu)');

legend(ax221,{'bus3','bus13'},'location','northeast');

%exporting data file
bus_v_dec = interp1(t,bus_v.',tt).';          % downsampling

H22 = {'t','c1','c2'};
M22 = [tt; abs(bus_v_dec(3,:)); abs(bus_v_dec(8,:))];

fid22 = fopen(fig22_name,'w');
fprintf(fid22,'%s,%s,%s\n',H22{:});
fprintf(fid22,'%6e,%6e,%6e\n',M22);
fclose(fid22);

% eof
