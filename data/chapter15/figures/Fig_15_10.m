% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.10

clear all; close all; clc;

% avr reference pulse with reec control
load('../mat/d2asbegp_exc_pert_reec_p4pu_bus91.mat');

%-------------------------------------%
% fig 10

fig10_name = './csv/ch15_fig10.csv';

Fs = 30;                                      % sample rate
tt = t(1):1/Fs:t(end);                        % time vector

fig10 = figure;
ax101 = subplot(2,1,1,'parent',fig10);
ax102 = subplot(2,1,2,'parent',fig10);
hold(ax101,'on');
hold(ax102,'on');

% plotting

qerr = g.reec.dreec4(1,:)/g.reec.reec_con(1,22);
y_piq = g.reec.reec_con(1,21).*qerr + g.reec.reec4(1,:);

plot(ax101, t, g.reec.reec3(1,:), [0, 20], ...
     [g.reec.reec3(1,1), g.reec.reec3(1,1)]);
plot(ax102,t,g.reec.reec8(1,:),t,y_piq);

v = axis(ax101);
axis(ax101,[v(1),6,v(3)-(v(4)-v(3))*0.05,v(4)+(v(4)-v(3))*0.05]);

v = axis(ax102);
axis(ax102,[v(1),6,v(3)-(v(4)-v(3))*0.05,v(4)+(v(4)-v(3))*0.02]);

legend(ax101,'$\widetilde{Q}_{\mathrm{gen}}$','$Q_{\mathrm{ref}}$', ...
       'interpreter','latex','location','best');
legend(ax102,'$V_{c}$','$V_{\mathrm{ref}}$', ...
       'interpreter','latex','location','best');

ylabel(ax101,'Reactive Power (pu)');
ylabel(ax102,'Voltage (pu)');
xlabel(ax102,'Time (s)');

y_piq_dec = interp1(t,y_piq,tt);              % downsampling
v_cmp_dec = interp1(t,g.reec.reec8(1,:),tt);
q_inj_dec = interp1(t,g.reec.reec3(1,:),tt);
q_ref_dec = interp1([0,20],[g.reec.reec3(1,1),g.reec.reec3(1,1)],tt);

H10 = {'t','y_piq','y_cmp','q_inj','q_ref'};
M10 = [tt; y_piq_dec; v_cmp_dec; q_inj_dec; q_ref_dec];

fid10 = fopen(fig10_name,'w');
fprintf(fid10,'%s,%s,%s,%s,%s\n',H10{:});
fprintf(fid10,'%6e,%6e,%6e,%6e,%6e\n',M10);
fclose(fid10);

% eof
