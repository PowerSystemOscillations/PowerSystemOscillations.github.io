% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.4

% d2adcemtran.mat: 2-area system with dc exciters, nonlinear simulation

clear all; close all; clc;
load('../mat/d2adcemtran.mat');

%-------------------------------------%
% fig 4

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector for downsampling

fig4_name = './csv/ch10_fig4.csv';

fig4 = figure;
ax41 = subplot(1,1,1,'parent',fig4);
hold(ax41,'on');

plot(ax41, t, abs(bus_v([3,8],:)));

v = axis(ax41);
axis(ax41,[0,5,v(3),v(4)]);
legend(ax41,{'bus 3','bus 13'},'location','southeast');

xlabel(ax41,'Time (s)');
ylabel(ax41,'Voltage magnitude (pu)');

bus_vm_dec = interp1(t,abs(bus_v).',tt).';   % downsampling

H4 = {'t','v3','v13'};
M4 = [tt; bus_vm_dec(3,:); bus_vm_dec(8,:)];

fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s\n',H4{:});  % must match number of columns
fprintf(fid4,'%6e,%6e,%6e\n',M4);  % must match number of columns
fclose(fid4);

% eof
