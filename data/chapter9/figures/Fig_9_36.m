% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.36

% nom_perf_sigma.mat: nominal performance
% rob_perf_sigma.mat: robust performance

clear all; close all; clc;
load('../mat/nom_perf_sigma.mat');
load('../mat/rob_perf_sigma.mat');

%-------------------------------------%
% fig 36

fig36_name = './csv/ch9_fig36.csv';

fig36 = figure;
ax361 = subplot(1,1,1,'parent',fig36);
hold(ax361,'on');
fh{1} = plot(ax361,w/(2*pi),SV_G42_mf(1,:));    % nominal performance
fh{2} = plot(ax361,w/(2*pi),RP_struct);         % performance structured (0.3307)
fh{3} = plot(ax361,w/(2*pi),squeeze(RESP1).');  % stability structured   (0.7843)
fh{4} = plot(ax361,w/(2*pi),RP_Zhou);           % performance full       (0.4359)
fh{5} = plot(ax361,w/(2*pi),SV_G8w(1,:));       % stability full         (0.8530)
plot(ax361,[0.01 100],[1 1]); % nominal performance

set(ax361,'xscale','log');
set(ax361,'yscale','log');

legend(ax361,[fh{1},fh{2},fh{3},fh{4},fh{5}],{'Nominal performance', ...
        'Robust Performance, structured uncertainty', ...
        'Robust stability, structured uncertainty', ...
        'Robust Performance, full uncertainty', ...
        'Robust stability, full uncertainty'}, ...
        'location','best');

axis(ax361,[0.01 100 1e-4 1e1]);
xlabel('Frequency (Hz)');

% exporting data file
H36 = {'w','svg42mf','rpstruct','resp1','rpzhou','svg8w'};
M36 = [w.'/(2*pi); SV_G42_mf(1,:); RP_struct; squeeze(RESP1).'; RP_Zhou; SV_G8w(1,:)];

fid36 = fopen(fig36_name,'w');
fprintf(fid36,'%s,%s,%s,%s,%s,%s\n',H36{:});
fprintf(fid36,'%6e,%6e,%6e,%6e,%6e,%6e\n',M36);
fclose(fid36);

% eof
