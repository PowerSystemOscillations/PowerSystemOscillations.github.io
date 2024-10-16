%% fig 10.37

clear all; close all; clc;
load('d2atcsct.mat');
Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector for downsampling

fig37_name = './dat/ch10_fig37.dat';

fig37 = figure;
ax371 = subplot(1,1,1,'parent',fig37);
hold(ax371,'on');

plot(ax371, t, abs(bus_v([3,8],:)));

v = axis(ax371);
axis(ax371,[0,20,v(3),v(4)]);
legend(ax371,{'bus 3','bus 13'},'location','southeast');

xlabel(ax371,'Time (s)');
ylabel(ax371,'Voltage magnitude (pu)');

bus_vm_dec = interp1(t,abs(bus_v).',tt).';   % downsampling

H37 = {'t','v3','v13'};
M37 = [tt; bus_vm_dec(3,:); bus_vm_dec(8,:)];

fid37 = fopen(fig37_name,'w');
fprintf(fid37,'%s,%s,%s\n',H37{:});  % must match number of columns
fprintf(fid37,'%6e,%6e,%6e\n',M37);  % must match number of columns
fclose(fid37);

% eof
