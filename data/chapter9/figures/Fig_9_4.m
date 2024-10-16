% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.4

% sbstsp.mat: 2-area syst. with detailed gen. models d2asb.m, state-space

clear all; close all; clc;                    % reset workspace
load('../mat/sbstsp.mat');                    % load data file

%-------------------------------------%
% fig 4

Fs = 240;                                     % sample rate
ts = 0:1/Fs:20;                               % time vector

fig4_name = './csv/ch9_fig4.csv';

fig4 = figure;
ax41 = subplot(2,1,1,'parent',fig4);
ax42 = subplot(2,1,2,'parent',fig4);
hold(ax41,'on');
hold(ax42,'on');

% Individual load modulation
% Voltage plots
% Load 1
G = ss(a_mat,[b_lmod b_rlmod]*[1; 0; 0; 0],c_v, zeros(13,1));
[y1,tt] = step(G,ts);
plot(ax41,tt,0.05*y1(:,[3 8]));               % upper half of Fig. 9.4
legend(ax41,'load1, bus 3 v','load1, bus 13 v','location','best')

% Load 2
G = ss(a_mat,[b_lmod b_rlmod]*[0; 1; 0; 0],c_v, zeros(13,1));
[y2,tt] = step(G,ts);
plot(ax42,tt,0.05*y2(:,[3 8]));               % lower half of Fig. 9.4
legend(ax42,'load2, bus 3 v','load2, bus 13 v','location','best');

ylabel(ax41,'Volt. dev. (pu)');
ylabel(ax42,'Volt. dev. (pu)');
xlabel(ax42,'Time (s)');

% downsampling
Fsi = 30;                                     % sample rate
ti = ts(1):1/Fsi:ts(end);                     % time vector
y1i = interp1(ts,y1,ti);                      % downsampling
y2i = interp1(ts,y2,ti);                      % downsampling

% exporting data file
H4 = {'t','y1b3','y1b13','y2b3','y2b13'};
M4 = [ti; 0.05*y1i(:,3).'; 0.05*y1i(:,8).'; 0.05*y2i(:,3).'; 0.05*y2i(:,8).'];

fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s,%s,%s\n',H4{:});
fprintf(fid4,'%6e,%6e,%6e,%6e,%6e\n',M4);
fclose(fid4);

% eof
