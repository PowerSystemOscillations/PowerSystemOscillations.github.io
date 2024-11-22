% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.16

clear all; close all; clc;

%-------------------------------------%
% fig 16

fig16_name = './csv/ch15_fig16.csv';

fig16 = figure;
ax161 = subplot(2,1,1,'parent',fig16);
ax162 = subplot(2,1,2,'parent',fig16);
hold(ax161,'on');
hold(ax162,'on');
set(ax161,'xscale','log');
set(ax162,'xscale','log');

t_final = 5;
H_flag = 0;

Fs = 120;
tt = 0:1/Fs:t_final;

% vsm analysis

run('../tools/vsm_parameter_setup.m');

plot(ax161,w/2/pi,20*log10(squeeze(m_vsm)));
plot(ax162,w/2/pi,squeeze(p_vsm));

bode_track{1} = [w/2/pi; 20*log10(squeeze(m_vsm)).'; squeeze(p_vsm).'];

H_vec = [5,10];
for ii = 1:length(H_vec)
    H_ii = H_vec(ii);
    G_vin_vsm_ii = tf([0,1],[2*H_ii,0]);      % inertia

    % vsm control (with negative input, positive feedback convention)
    T_vsm_ii = feedback(G_vin_vsm_ii,parallel(G_dmp_vsm,G_drp_vsm));
    T_vsmlin_ii = feedback(G_fwd,T_vsm_ii);

    [m_vsm_ii,p_vsm_ii] = bode(T_vsmlin_ii,w);

    plot(ax161,w/2/pi,20*log10(squeeze(m_vsm_ii)));
    plot(ax162,w/2/pi,squeeze(p_vsm_ii));
    bode_track{ii+1} = [w/2/pi; 20*log10(squeeze(m_vsm_ii)).'; squeeze(p_vsm_ii).'];
end

v = axis(ax161);
axis(ax161,[v(1),100,v(3),v(4)]);

v = axis(ax162);
axis(ax162,[v(1),100,-180,180]);

legend(ax161,{'$H=2.5$','$H=5$','$H=10$'},'interpreter','latex','location','best');
legend(ax162,{'$H=2.5$','$H=5$','$H=10$'},'interpreter','latex','location','best');

ylabel(ax161,'Amplitude (dB)');
ylabel(ax162,'Phase (deg)');
xlabel(ax162,'Frequency (Hz)');

% exporting data

f = bode_track{1}(1,:);
H16 = {'f','m1','p1','m2','p2','m3','p3'};
M16 = [f; bode_track{1}(2,:); bode_track{1}(3,:); ...
       bode_track{2}(2,:); bode_track{2}(3,:); ...
       bode_track{3}(2,:); bode_track{3}(3,:)];

fid16 = fopen(fig16_name,'w');
fprintf(fid16,'%s,%s,%s,%s,%s,%s,%s\n',H16{:});
fprintf(fid16,'%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M16);
fclose(fid16);

% eof
