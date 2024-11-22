% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.34

% d2atcsct.mat: 2-area test case with dc exciters and tcsc control,
%               nonlinear simulation

clear all; close all; clc;
load('../mat/d2atcsct.mat');

%-------------------------------------%
% fig 34

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig34_name = './csv/ch10_fig34.csv';

fig34 = figure;
ax341 = subplot(1,1,1,'parent',fig34);
hold(ax341,'on');

plot(ax341, t, abs(bus_v([3,8],:)));

v = axis(ax341);
axis(ax341,[0,20,v(3),v(4)]);
legend(ax341,{'bus 3','bus 13'},'location','southeast');

xlabel(ax341,'Time (s)');
ylabel(ax341,'Voltage magnitude (pu)');

% exporting data

bus_vm_dec = interp1(t,abs(bus_v).',tt).';    % downsampling

H34 = {'t','v3','v13'};
M34 = [tt; bus_vm_dec(3,:); bus_vm_dec(8,:)];

fid34 = fopen(fig34_name,'w');
fprintf(fid34,'%s,%s,%s\n',H34{:});
fprintf(fid34,'%6e,%6e,%6e\n',M34);
fclose(fid34);

% eof
