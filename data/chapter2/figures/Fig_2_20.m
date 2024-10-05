% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.20

% sbegtranvr1: step change of 0.01 in Vref of generator 1 (fig. 19, 20)

clear all; close all; clc;
load('../mat/sbegtranvr1.mat');

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 20

fig20_name = './csv/ch2_fig20.csv';

fig20 = figure;
ax201 = subplot(2,1,1,'parent',fig20);
ax202 = subplot(2,1,2,'parent',fig20);
hold(ax201,'on');
hold(ax202,'on');
plot(ax201, t, eterm(1,:)-eterm(1,1));
plot(ax201, t, eterm(2,:)-eterm(2,1));
plot(ax202, t, eterm(3,:)-eterm(3,1));
plot(ax202, t, eterm(4,:)-eterm(4,1));

% axis labels
xlabel(ax202,'Time (s)');
ylabel(ax201,'Voltage change (pu)');
ylabel(ax202,'Voltage change (pu)');
v = axis(ax201);
axis(ax201,[v(1),v(2),v(3)-0.6e-3,v(4)+0.6e-3]);
axis(ax202,[v(1),v(2),v(3)-0.6e-3,v(4)+0.6e-3]);

% ingraph legend
legend(ax201,{'gen1','gen2'},'location','best');
legend(ax202,{'gen3','gen4'},'location','best');

% exporting data file
eterm_dec = interp1(t,eterm.',tt).';            % downsampling

H20 = {'t','c1','c2','c3','c4'};
M20 = [tt; eterm_dec(1,:)-eterm_dec(1,1); eterm_dec(2,:)-eterm_dec(2,1); ...
         eterm_dec(3,:)-eterm_dec(3,1); eterm_dec(4,:)-eterm_dec(4,1)];

fid20 = fopen(fig20_name,'w');
fprintf(fid20,'%s,%s,%s,%s,%s\n',H20{:});
fprintf(fid20,'%6e,%6e,%6e,%6e,%6e\n',M20);
fclose(fid20);

% eof
