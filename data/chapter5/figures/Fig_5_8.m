% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 5.8

% 16m2ttran.mat: 16-machine system with a two ties between areas 4 and 5

clear all; close all; clc;                    % reset workspace
load('../mat/16m2ttran.mat');                 % data file

Fs = 15;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig8_name = './csv/ch5_fig8.csv';

fig8 = figure;
ax81 = subplot(1,1,1,'parent',fig8);
hold(ax81,'on');

ang_idx = 1:9;
bus_idx = [2:8,10:29,53:61];

plot(ax81,t,mac_ang(ang_idx,:),t,unwrap(angle(bus_v(bus_idx,:)),[],2));
xlabel(ax81,'Time (s)');
ylabel(ax81,'Angle (rad)');
% legend(ax81,'gen 1','bus 23','location','southEast');

% exporting data file
mac_ang_dec = interp1(t,mac_ang.',tt).';
bus_ang_dec = interp1(t,unwrap(angle(bus_v),[],2).',tt).';

H8 = {'t'};
M8 = [tt];
s_str = '%s,';
e_str = '%e,';
for ii = 1:length(ang_idx)
    H8 = [H8, ['a',num2str(ii)]];
    M8 = [M8; mac_ang_dec(ang_idx(ii),:)];
    s_str = [s_str, '%s,'];
    e_str = [e_str, '%6e,'];
end

for ii = 1:length(bus_idx)
    H8 = [H8, ['b',num2str(ii)]];
    M8 = [M8; bus_ang_dec(bus_idx(ii),:)];
    s_str = [s_str, '%s,'];
    e_str = [e_str, '%6e,'];
end

fid8 = fopen(fig8_name,'w');
fprintf(fid8,[s_str(1:end-1),'\n'],H8{:});
fprintf(fid8,[e_str(1:end-1),'\n'],M8);
fclose(fid8);

% eof
