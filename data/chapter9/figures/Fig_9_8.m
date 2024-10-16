% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.8

% sbegpstsp.mat: 2-area system with exciters and governors post-fault, state-space

clear all; close all; clc;                    % reset workspace
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 8

Fs = 480;                                     % sample rate
ts = 0:1/Fs:20;                               % time vector

fig8_name = './csv/ch9_fig8.csv';

fig8 = figure;
ax81 = subplot(2,1,1,'parent',fig8);
ax82 = subplot(2,1,2,'parent',fig8);
hold(ax81,'on');
hold(ax82,'on');

% Individual load modulation
% Voltage plots
% Load 1
G = ss(a_mat,[b_lmod b_rlmod]*[1; 0; 0; 0],c_v, zeros(13,1));
[y1,tt] = step(G,ts);
plot(ax81,tt,0.05*y1(:,[3 8]))                % upper half of Fig. 9.8
legend(ax81,'load 1, bus 3','load 1, bus 13','location','best');

% Load 2
G = ss(a_mat,[b_lmod b_rlmod]*[0; 1; 0; 0],c_v, zeros(13,1));
[y2,tt] = step(G,ts);
plot(ax82,tt,0.05*y2(:,[3 8]))                % lower half of Fig. 9.8
legend(ax82,'load 2, bus 3','load 2, bus 13','location','best');

ylabel(ax81,'Volt. dev. (pu)');
ylabel(ax82,'Volt. dev. (pu)');
xlabel(ax82,'Time (s)');

% downsampling
Fsi = 30;                                     % sample rate
ti = ts(1):1/Fsi:ts(end);                     % time vector
y1i = interp1(ts,y1,ti);                      % downsampling
y2i = interp1(ts,y2,ti);                      % downsampling

% exporting data file
H8 = {'t','y1b3','y1b13','y2b3','y2b13'};
M8 = [ti; 0.05*y1i(:,3).'; 0.05*y1i(:,8).'; 0.05*y2i(:,3).'; 0.05*y2i(:,8).'];

fid8 = fopen(fig8_name,'w');
fprintf(fid8,'%s,%s,%s,%s,%s\n',H8{:});
fprintf(fid8,'%6e,%6e,%6e,%6e,%6e\n',M8);
fclose(fid8);

% eof
