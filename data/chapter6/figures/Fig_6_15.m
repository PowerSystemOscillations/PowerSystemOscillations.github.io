% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.15

% stexcss.mat: static exciter analysis

clear all; close all; clc;                    % reset workspace
load('../mat/stexcss.mat');                   % state-space model

%-------------------------------------%
% fig 15

fig15_name = './csv/ch6_fig15.csv';

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig15 = figure;
ax151 = subplot(1,1,1,'parent',fig15);
hold(ax151,'on');

plot(ax151,t,rstexc);
xlabel(ax151,'Time (s)');
ylabel(ax151,'Terminal voltage deviation (pu)');

% exporting data file
step_response_dec = interp1(t,rstexc.',tt);   % downsampling

H15 = {'t','r'};
M15 = [tt; step_response_dec];

fid15 = fopen(fig15_name,'w');
fprintf(fid15,'%s,%s\n',H15{:});
fprintf(fid15,'%6e,%6e\n',M15);
fclose(fid15);

% eof