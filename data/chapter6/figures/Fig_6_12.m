% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.12

% dcexcss.mat: dc exciter analysis

clear all; close all; clc;                    % reset workspace
load('../mat/dcexcss.mat');                   % state-space model

%-------------------------------------%
% fig 12

Fs = 30;                                      % sample rate
tt = ttgr(1):1/Fs:ttgr(end);                  % time vector

fig12_name = './csv/ch6_fig12.csv';

fig12 = figure;
ax121 = subplot(1,1,1,'parent',fig12);
hold(ax121,'on');

plot(ax121,ttgr,rtgr);
xlabel(ax121,'Time (s)');
ylabel(ax121,'Terminal voltage deviation (pu)');

% exporting data file
step_response_dec = interp1(ttgr,rtgr.',tt);  % downsampling

H12 = {'t','r'};
M12 = [tt; step_response_dec];

fid12 = fopen(fig12_name,'w');
fprintf(fid12,'%s,%s\n',H12{:});
fprintf(fid12,'%6e,%6e\n',M12);
fclose(fid12);

% eof
