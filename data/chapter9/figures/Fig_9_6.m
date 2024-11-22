% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.6

% sbegstsp.mat: 2-area syst. with detailed gen. models, exciters,
%               and turbine/governors, d2asbeg.m (state space)

clear all; close all; clc;                    % reset workspace
load('../mat/sbegstsp.mat');                  % load data file

%-------------------------------------%
% fig 6

Fs = 240;                                     % sample rate
ts = 0:1/Fs:20;                               % time vector

fig6_name = './csv/ch9_fig6.csv';

fig6 = figure;
ax61 = subplot(2,1,1,'parent',fig6);
ax62 = subplot(2,1,2,'parent',fig6);
hold(ax61,'on');
hold(ax62,'on');

% Individual load modulatio
% Voltage plots
% Load 1
G = ss(a_mat,[b_lmod b_rlmod]*[1; 0; 0; 0],c_v, zeros(13,1));
[y1,tt] = step(G,ts);
plot(ax61,tt,0.05*y1(:,[3 8]));               % upper half of Fig. 9.6
legend(ax61,'load1, bus 3 v','load1, bus 13 v','location','best')

% Load 2
G = ss(a_mat,[b_lmod b_rlmod]*[0; 1; 0; 0],c_v, zeros(13,1));
[y2,tt] = step(G,ts);
plot(ax62,tt,0.05*y2(:,[3 8]));               % lower half of Fig. 9.6
legend(ax62,'load2, bus 3 v','load2, bus 13 v','location','best');

ylabel(ax61,'Volt. dev. (pu)');
ylabel(ax62,'Volt. dev. (pu)');
xlabel(ax62,'Time (s)');

% downsampling
Fsi = 30;                                     % sample rate
ti = ts(1):1/Fsi:ts(end);                     % time vector
y1i = interp1(ts,y1,ti);                      % downsampling
y2i = interp1(ts,y2,ti);                      % downsampling

% exporting data file
H6 = {'t','y1b3','y1b13','y2b3','y2b13'};
M6 = [ti; 0.05*y1i(:,3).'; 0.05*y1i(:,8).'; 0.05*y2i(:,3).'; 0.05*y2i(:,8).'];

fid6 = fopen(fig6_name,'w');
fprintf(fid6,'%s,%s,%s,%s,%s\n',H6{:});
fprintf(fid6,'%6e,%6e,%6e,%6e,%6e\n',M6);
fclose(fid6);

% eof
