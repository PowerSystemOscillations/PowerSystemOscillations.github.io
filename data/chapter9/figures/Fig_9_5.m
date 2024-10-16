% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.5

% sbstsp.mat: 2-area syst. with detailed gen. models d2asb.m, state-space

clear all; close all; clc;                  % reset workspace
load('../mat/sbstsp.mat');                  % load data file

%-------------------------------------%
% fig 5

Fs = 240;                                   % sample rate
ts = 0:1/Fs:20;                             % time vector

fig5_name = './csv/ch9_fig5.csv';

fig5 = figure;
ax51 = subplot(2,1,1,'parent',fig5);
ax52 = subplot(2,1,2,'parent',fig5);
hold(ax51,'on');
hold(ax52,'on');

% Frequency plots
% Load 1
G = ss(a_mat,[b_lmod b_rlmod]*[1; 0; 0; 0],c_ang, zeros(13,1));
[y3,tt] = step(G,ts);
y3 = y3.';

% frequency calculation filter
[b,a] = besself(2,2*pi*3);
b = [b,0]/(2*pi*60);                          % cascade with derivative
a = [0,a];

[bd,ad] = bilinear(b,a,Fs);                   % bilinear transformation

f3 = zeros(size(y3,1),length(tt));
for ii = 1:size(y3,1)
    Zi = filtic(bd,ad,zeros(3,1),y3(ii,1)*ones(3,1));
    f3(ii,:) = filter(bd,ad,y3(ii,:),Zi);
end

plot(ax51,tt,0.05*60e3*f3([3,8],:));          % upper half of Fig. 9.5
legend(ax51,'load1, bus 3','load1, bus 13','location','best');

% Load 2
G = ss(a_mat,[b_lmod b_rlmod]*[0; 1; 0; 0],c_ang, zeros(13,1));
[y4,tt] = step(G,ts);
y4 = y4.';

f4 = zeros(size(y4,1),length(tt));
for ii = 1:size(y4,1)
    Zi = filtic(bd,ad,zeros(3,1),y4(ii,1)*ones(3,1));
    f4(ii,:) = filter(bd,ad,y4(ii,:),Zi);
end

plot(ax52,tt,0.05*60e3*f4([3,8],:));          % lower half of Fig. 9.5
legend(ax52,'load2, bus 3','load2, bus 13','location','best');

ylabel(ax51,'Freq. dev. (mHz)');
ylabel(ax52,'Freq. dev. (mHz)');
xlabel(ax52,'Time (s)');

v = axis(ax51);
axis(ax51,[v(1),v(2),-30,130]);

v = axis(ax52);
axis(ax52,[v(1),v(2),-30,130]);

% downsampling
Fsi = 30;                                     % sample rate
ti = ts(1):1/Fsi:ts(end);                     % time vector
f3i = interp1(ts,f3.',ti);                    % downsampling
f4i = interp1(ts,f4.',ti);                    % downsampling

% exporting data file
H5 = {'t','y1b3','y1b13','y2b3','y2b13'};
M5 = [ti; 0.05*f3i(:,3).'; 0.05*f3i(:,8).'; 0.05*f4i(:,3).'; 0.05*f4i(:,8).'];

fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e,%6e,%6e\n',M5);
fclose(fid5);

% eof
