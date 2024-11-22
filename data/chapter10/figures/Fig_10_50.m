% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.50

% d2aphvdct.mat: 2-area test case with hvdc, no supplemental control,
%                nonlinear simulation

clear all; close all; clc;
load('../mat/d2aphvdct.mat');

%-------------------------------------%
% fig 50

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig50_name = './csv/ch10_fig50.csv';

fig50 = figure;
ax501 = subplot(2,1,1,'parent',fig50);
ax502 = subplot(2,1,2,'parent',fig50);
hold(ax501,'on');
hold(ax502,'on');

plot(ax501, t, abs(bus_v([3,9],:)));

%--------------------------------------%
% bottom subplot

% d2aphvdct_cont2.mat: 2-area test case with hvdc, damping control 2,
%                      nonlinear simulation

load('../mat/d2aphvdct_cont2.mat');

plot(ax502, t, abs(bus_v([3,9],:)));

v = axis(ax501);
axis(ax501,[0,10,0.7,1.1]);
legend(ax501,{'bus 3','bus 13'},'location','best');

v = axis(ax502);
axis(ax502,[0,10,0.7,1.1]);
legend(ax502,{'bus 3','bus 13'},'location','southeast');

ylabel(ax501,'Voltage mag. (pu)');
ylabel(ax502,'Voltage mag. (pu)');
xlabel(ax502,'Time (s)');

bus_vm_dec = interp1(t,abs(bus_v).',tt).';    % downsampling

H50 = {'t','v3','v13'};
M50 = [tt; bus_vm_dec(3,:); bus_vm_dec(9,:)];

fid50 = fopen(fig50_name,'w');
fprintf(fid50,'%s,%s,%s\n',H50{:});
fprintf(fid50,'%6e,%6e,%6e\n',M50);
fclose(fid50);

% eof
