% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.9

clear all; close all; clc;

% avr reference pulse with gfma control
load('../mat/d2asbegp_exc_pert_gfma_p4pu_bus91.mat');

%-------------------------------------%
% fig 9

fig9_name = './csv/ch15_fig9.csv';

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig9 = figure;
ax91 = subplot(2,1,1,'parent',fig9);
ax92 = subplot(2,1,2,'parent',fig9);
hold(ax91,'on');
hold(ax92,'on');

q_gfm = 100*g.mac.qelect(5,:);
v_gfm = abs(g.bus.bus_v(14,:));
plot(ax91,t,v_gfm);
plot(ax92,t,q_gfm);

q_gfm_dec = interp1(t,q_gfm,tt);              % downsampling
v_gfm_dec = interp1(t,v_gfm,tt);

% avr reference pulse with reec control
load('../mat/d2asbegp_exc_pert_reec_p4pu_bus91.mat');

q_gfl = 100*imag(g.ess.ess_sinj(1,:));
v_gfl = abs(g.bus.bus_v(14,:));
plot(ax91,t,v_gfl);
plot(ax92,t,q_gfl);

q_gfl_dec = interp1(t,q_gfl,tt);              % downsampling
v_gfl_dec = interp1(t,v_gfl,tt);

ylabel(ax91,'Voltage (pu)');
ylabel(ax92,'Reactive Power (pu)');
xlabel(ax92,'Time (s)');

v = axis(ax91);
axis(ax91,[v(1),6,v(3)-(v(4)-v(3))*0.05,v(4)+(v(4)-v(3))*0.05]);

v = axis(ax92);
axis(ax92,[v(1),6,v(3)-(v(4)-v(3))*0.05,v(4)+(v(4)-v(3))*0.02]);

legend(ax91,{'gfma','reec'},'location','best');
legend(ax92,{'gfma','reec'},'location','best');

H9 = {'t','q_gfm','q_gfl','v_gfm','v_gfl'};
M9 = [tt; q_gfm_dec; q_gfl_dec; v_gfm_dec; v_gfl_dec];

% exporting data

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
