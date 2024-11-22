% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.13

clear all; close all; clc;
load('../mat/d2asbegp_step_base_p4pu.mat');   % base case (no IBRs)

%-------------------------------------%
% fig 13

fig13_name = './csv/ch15_fig13.csv';

fig13 = figure;
ax13 = subplot(1,1,1,'parent',fig13);
hold(ax13,'on');

Fs = 30;
tt = 0:1/Fs:20;

plot(ax13,t,60*mean(g.mac.mac_spd));

base_freq_dec = interp1(t,60*mean(g.mac.mac_spd),tt);

for ii = 1:3
    % grid-forming cases (gfma)
    load(['../mat/d2asbegp_step_gfma_p4pu_',num2str(ii),'ibr.mat']);
    plot(ax13,t,60*mean(g.mac.mac_spd));
    gfm_freq_dec{ii} = interp1(t,60*mean(g.mac.mac_spd),tt);
end

v = axis(ax13);
axis(ax13,[v(1),10,59.825,60.015]);

legend(ax13,{'base','1 gfma','2 gfma','3 gfma'});
ylabel(ax13,'Frequency (Hz)');
xlabel(ax13,'Time (s)');

% exporting data

H13 = {'t','f0','f1','f2','f3'};
M13 = [tt; base_freq_dec; gfm_freq_dec{1}; gfm_freq_dec{2}; gfm_freq_dec{3}];

fid13 = fopen(fig13_name,'w');
fprintf(fid13,'%s,%s,%s,%s,%s\n',H13{:});
fprintf(fid13,'%6e,%6e,%6e,%6e,%6e\n',M13);
fclose(fid13);

% eof
