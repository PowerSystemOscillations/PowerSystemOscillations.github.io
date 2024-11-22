% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.9

% sbegpstsp.mat: 2-area syst. with detailed gen. models, exciters,
%                turbine/governors, and PSSs, d2asbegp.m (state space)

clear all; close all; clc;                    % reset workspace
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 9

Fs = 480;                                     % sample rate
ts = 0:1/Fs:20;                               % time vector

fig9_name = './csv/ch9_fig9.csv';

fig9 = figure;
ax91 = subplot(2,1,1,'parent',fig9);
ax92 = subplot(2,1,2,'parent',fig9);
hold(ax91,'on');
hold(ax92,'on');

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

plot(ax91,tt,0.05*60e3*f3([3,8],:));          % upper half of Fig. 9.9
legend(ax91,'load1, bus 3','load1, bus 13','location','best');

% Load 2
G = ss(a_mat,[b_lmod b_rlmod]*[0; 1; 0; 0],c_ang, zeros(13,1));
[y4,tt] = step(G,ts);
y4 = y4.';

f4 = zeros(size(y4,1),length(tt));
for ii = 1:size(y4,1)
    Zi = filtic(bd,ad,zeros(3,1),y4(ii,1)*ones(3,1));
    f4(ii,:) = filter(bd,ad,y4(ii,:),Zi);
end

plot(ax92,tt,0.05*60e3*f4([3,8],:))           % lower half of Fig. 9.9
legend(ax92,'load2, bus 3 f','load2, bus 13 f','location','best');

ylabel(ax91,'Freq. dev. (pu)');
ylabel(ax92,'Freq. dev. (pu)');
xlabel(ax92,'Time (s)');

v = axis(ax91);
axis(ax91,[v(1),v(2),-4.5,0.5]);

v = axis(ax92);
axis(ax92,[v(1),v(2),-4.5,0.5]);

% downsampling
Fsi = 30;                                     % sample rate
ti = ts(1):1/Fsi:ts(end);                     % time vector
f3i = interp1(ts,f3.',ti);                    % downsampling
f4i = interp1(ts,f4.',ti);                    % downsampling

% exporting data file
H9 = {'t','y1b3','y1b13','y2b3','y2b13'};
M9 = [ti; 0.05*f3i(:,3).'; 0.05*f3i(:,8).'; 0.05*f4i(:,3).'; 0.05*f4i(:,8).'];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
