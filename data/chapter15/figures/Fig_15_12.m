% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.12

clear all; close all; clc;
load('../mat/d2asbegp_step_base_p4pu.mat');   % base case (no IBRs)

%-------------------------------------%
% fig 12

fig12_name = './csv/ch15_fig12.csv';

fig12 = figure;
ax12 = subplot(1,1,1,'parent',fig12);
hold(ax12,'on');

Fs = 30;
tt = 0:1/Fs:20;

plot(ax12,t,60*mean(g.mac.mac_spd))

base_freq_dec = interp1(t,60*mean(g.mac.mac_spd),tt);

for ii = 1:2
    % grid-following cases (reec)
    load(['../mat/d2asbegp_step_reec_p4pu_',num2str(ii),'ibr.mat']);
    plot(ax12,t,60*mean(g.mac.mac_spd));
    gfl_freq_dec{ii} = interp1(t,60*mean(g.mac.mac_spd),tt);
end

v = axis(ax12);
axis(ax12,[v(1),10,59.825,60.015]);

legend(ax12,{'base','1 reec','2 reec'});
ylabel(ax12,'Frequency (Hz)');
xlabel(ax12,'Time (s)');

% exporting data

H12 = {'t','f0','f1','f2'};
M12 = [tt; base_freq_dec; gfl_freq_dec{1}; gfl_freq_dec{2}];

fid12 = fopen(fig12_name,'w');
fprintf(fid12,'%s,%s,%s,%s\n',H12{:});
fprintf(fid12,'%6e,%6e,%6e,%6e\n',M12);
fclose(fid12);

% eof
