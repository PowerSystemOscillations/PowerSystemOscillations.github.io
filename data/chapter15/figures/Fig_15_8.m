% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.8

clear all; close all; clc;

% governor reference pulse with gfma control
load('../mat/d2asbegp_tg_pert_gfma_p4pu_bus91.mat');

%-------------------------------------%
% fig 8

fig8_name = './csv/ch15_fig8.csv';

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig8 = figure;
ax81 = subplot(2,1,1,'parent',fig8);
ax82 = subplot(2,1,2,'parent',fig8);
hold(ax81,'on');
hold(ax82,'on');

p_gfm = 100*g.mac.pelect(5,:);
f_gfm = 60*g.freq.bus_freq(14,:);
plot(ax81,t,f_gfm);
plot(ax82,t,p_gfm);

p_gfm_dec = interp1(t,p_gfm,tt);              % downsampling
f_gfm_dec = interp1(t,f_gfm,tt);

% governor reference pulse with reec control
load('../mat/d2asbegp_tg_pert_reec_p4pu_bus91.mat');

p_gfl = 100*real(g.ess.ess_sinj(1,:));
f_gfl = 60*g.freq.bus_freq(14,:);
plot(ax81,t,f_gfl);
plot(ax82,t,p_gfl);

%xlabel(ax81,'Time (s)');
xlabel(ax82,'Time (s)');

ylabel(ax81,'Frequency (Hz)');
ylabel(ax82,'Power (MW)');

legend(ax81,{'gfma','reec'},'location','best');
legend(ax82,{'gfma','reec'},'location','best');

v = axis(ax81);
axis(ax81,[v(1),10,v(3)-(v(4)-v(3))*0.05,v(4)+(v(4)-v(3))*0.01]);

v = axis(ax82);
axis(ax82,[v(1),10,v(3)-(v(4)-v(3))*0.05,v(4)+(v(4)-v(3))*0.05]);

p_gfl_dec = interp1(t,p_gfl,tt);              % downsampling
f_gfl_dec = interp1(t,f_gfl,tt);

H8 = {'t','p_gfm','p_gfl','f_gfm','f_gfl'};
M8 = [tt; p_gfm_dec; p_gfl_dec; f_gfm_dec; f_gfl_dec];

fid8 = fopen(fig8_name,'w');
fprintf(fid8,'%s,%s,%s,%s,%s\n',H8{:});
fprintf(fid8,'%6e,%6e,%6e,%6e,%6e\n',M8);
fclose(fid8);

% eof
