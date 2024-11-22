% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.17

clear all; close all; clc;

%-------------------------------------%
% fig 17

fig17_name = './csv/ch15_fig17.csv';

fig17 = figure;
ax17 = subplot(1,1,1,'parent',fig17);
hold(ax17,'on');

t_final = 5;
s_step = 0.01;
H_flag = 0;

Fs = 120;
tt = 0:1/Fs:t_final;

% vsm analysis

run('../tools/vsm_parameter_setup.m');

[y1,t1] = step(T_vsmlin,t_final);
plot(ax17,[0;t1+0.5],[0;s_step*y1]);

step_track{1} = interp1([0;t1+0.5],[0;s_step*y1],tt.');

H_vec = [5,10];
for ii = 1:length(H_vec)
    H_ii = H_vec(ii);
    G_vin_vsm_ii = tf([0,1],[2*H_ii,0]);      % inertia

    % vsm control (with negative input)
    T_vsm_ii = feedback(G_vin_vsm_ii,parallel(G_dmp_vsm,G_drp_vsm));
    T_vsmlin_ii = feedback(G_fwd,T_vsm_ii);

    [y,t] = step(T_vsmlin_ii,t_final);
    plot(ax17,[0;t+0.5],[0;s_step*y]);
    step_track{ii+1} = interp1([0;t+0.5],[0;s_step*y],tt.');
end

[y,t] = step(T_drplin,t_final);
plot(ax17,[0;t+0.5],[0;s_step*y]);
step_track{ii+2} = interp1([0;t+0.5],[0;s_step*y],tt.');

v = axis(ax17);
axis(ax17,[v(1),2.5,-3,3]);

legend(ax17,{'$H=2.5$','$H=5$','$H=10$'},'interpreter','latex','location','best');
ylabel(ax17,'Power deviation (pu)');
xlabel(ax17,'Time (s)');

% exporting data

H17 = {'t','s1','s2','s3','s4'};
M17 = [tt; step_track{1}(:,1).'; step_track{2}(:,1).'; ...
       step_track{3}(:,1).';  step_track{4}(:,1).'];

fid17 = fopen(fig17_name,'w');
fprintf(fid17,'%s,%s,%s,%s,%s\n',H17{:});
fprintf(fid17,'%6e,%6e,%6e,%6e,%6e\n',M17);
fclose(fid17);

% eof
