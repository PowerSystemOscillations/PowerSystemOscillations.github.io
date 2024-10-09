% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.10

% dcexcss.mat: dc exciter analysis

clear all; close all; clc;                    % reset workspace
load('../mat/dcexcss.mat');                   % state-space model

%-------------------------------------%
% fig 10

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig10_name = './csv/ch6_fig10.csv';

fig10 = figure;
ax101 = subplot(1,1,1,'parent',fig10);
hold(ax101,'on');

plot(ax101,t,strdce);
xlabel(ax101,'Time (s)');
ylabel(ax101,'Terminal voltage deviation (pu)');

% exporting data file
step_response_dec = interp1(t,strdce.',tt);   % downsampling

H10 = {'t','r'};
M10 = [tt; step_response_dec];

fid10 = fopen(fig10_name,'w');
fprintf(fid10,'%s,%s\n',H10{:});
fprintf(fid10,'%6e,%6e\n',M10);
fclose(fid10);

% eof