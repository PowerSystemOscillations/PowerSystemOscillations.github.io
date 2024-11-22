% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.19

clear all; close all; clc;

%-------------------------------------%
% fig 19

fig19_name = './csv/ch15_fig19.csv';

fig19 = figure;
ax19 = subplot(1,1,1,'parent',fig19);
hold(ax19,'on');

t_final = 5;
s_step = 0.01;
H_flag = 0;

Fs = 120;
tt = 0:1/Fs:t_final;

% vsm analysis

run('../tools/vsm_parameter_setup.m');

[y1,t1] = step(T_vsmlin,t_final);
plot(ax19,[0;t1+0.5],[0;s_step*y1]);

step_track{1} = interp1([0;t1+0.5],[0;s_step*y1],tt.');

Kw_vec = (1/mp)*[2,4];
for ii = 1:length(Kw_vec)
    Kw_ii = Kw_vec(ii);
    G_dmp_vsm_ii = tf([Kw_ii*Tw,0],[Tw,1]);   % damping

    % vsm control (with negative input, positive feedback convention)
    T_vsm_ii = feedback(G_vin_vsm,parallel(G_dmp_vsm_ii,G_drp_vsm));
    T_vsmlin_ii = feedback(G_fwd,T_vsm_ii);

    [y,t] = step(T_vsmlin_ii,t_final);
    plot(ax19,[0;t+0.5],[0;s_step*y]);
    step_track{ii+1} = interp1([0;t+0.5],[0;s_step*y],tt.');
end

[y,t] = step(T_drplin,t_final);
plot(ax19,[0;t+0.5],[0;s_step*y]);
step_track{ii+2} = interp1([0;t+0.5],[0;s_step*y],tt.');

v = axis(ax19);
axis(ax19,[v(1),2.5,-3,3]);

legend(ax19,{'$A=20$','$A=40$','$A=80$'},'interpreter','latex','location','best');

ylabel(ax19,'Power deviation (pu)');
xlabel(ax19,'Time (s)');

% exporting data

H19 = {'t','s1','s2','s3','s4'};
M19 = [tt; step_track{1}(:,1).'; step_track{2}(:,1).'; ...
       step_track{3}(:,1).';  step_track{4}(:,1).'];

fid19 = fopen(fig19_name,'w');
fprintf(fid19,'%s,%s,%s,%s,%s\n',H19{:});
fprintf(fid19,'%6e,%6e,%6e,%6e,%6e\n',M19);
fclose(fid19);

% eof
