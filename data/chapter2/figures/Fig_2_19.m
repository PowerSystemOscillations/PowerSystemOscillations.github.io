% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.19

% sbegtranvr1: step change of 0.01 in Vref of generator 1 (fig. 19, 20)

clear all; close all; clc;
load('../mat/sbegtranvr1.mat');

Fs = 30;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

%-------------------------------------%
% fig 19

fig19_name = './csv/ch2_fig19.csv';

fig19 = figure;
ax191 = subplot(2,1,1,'parent',fig19);
ax192 = subplot(2,1,2,'parent',fig19);
hold(ax191,'on');
hold(ax192,'on');
plot(ax191, t, Efd(1,:));
plot(ax191, t, Efd(2,:));
plot(ax192, t, Efd(3,:));
plot(ax192, t, Efd(4,:));

% axis labels
xlabel(ax192,'Time (s)');
ylabel(ax191,'Generator field voltage (pu)');
ylabel(ax192,'Generator field voltage (pu)');
v = axis(ax191);
axis(ax191,[v(1),v(2),1.4,3.4]);
axis(ax192,[v(1),v(2),1.4,3.4]);

% ingraph legend
legend(ax191,{'gen1','gen2'},'location','best');
legend(ax192,{'gen3','gen4'},'location','best');

% exporting data file
Efd_dec = interp1(t,Efd.',tt).';            % downsampling

H19 = {'t','c1','c2','c3','c4'};
M19 = [tt; Efd_dec(1,:); Efd_dec(2,:); Efd_dec(3,:); Efd_dec(4,:)];

fid19 = fopen(fig19_name,'w');
fprintf(fid19,'%s,%s,%s,%s,%s\n',H19{:});
fprintf(fid19,'%6e,%6e,%6e,%6e,%6e\n',M19);
fclose(fid19);

% eof
