% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.16

clear all; close all; clc;

%-------------------------------------%
% fig 16

fig18_name = './csv/ch15_fig18.csv';

fig18 = figure;
ax181 = subplot(2,1,1,'parent',fig18);
ax182 = subplot(2,1,2,'parent',fig18);
hold(ax181,'on');
hold(ax182,'on');
set(ax181,'xscale','log');
set(ax182,'xscale','log');

t_final = 5;
H_flag = 0;

Fs = 120;
tt = 0:1/Fs:t_final;

% vsm analysis

run('../tools/vsm_parameter_setup.m');

plot(ax181,w/2/pi,20*log10(squeeze(m_vsm)));
plot(ax182,w/2/pi,squeeze(p_vsm));

bode_track{1} = [w/2/pi; 20*log10(squeeze(m_vsm)).'; squeeze(p_vsm).'];

Kw_vec = (1/mp)*[2,4];
for ii = 1:length(Kw_vec)
    Kw_ii = Kw_vec(ii);
    G_dmp_vsm_ii = tf([Kw_ii*Tw,0],[Tw,1]);   % damping

    % vsm control (with negative input, positive feedback convention)
    T_vsm_ii = feedback(G_vin_vsm,parallel(G_dmp_vsm_ii,G_drp_vsm));
    T_vsmlin_ii = feedback(G_fwd,T_vsm_ii);

    [m_vsm_ii,p_vsm_ii] = bode(T_vsmlin_ii,w);

    plot(ax181,w/2/pi,20*log10(squeeze(m_vsm_ii)));
    plot(ax182,w/2/pi,squeeze(p_vsm_ii));
    bode_track{ii+1} = [w/2/pi; 20*log10(squeeze(m_vsm_ii)).'; squeeze(p_vsm_ii).'];
end

v = axis(ax181);
axis(ax181,[v(1),100,v(3)-(v(4)-v(3))*0.01,v(4)+(v(4)-v(3))*0.09]);

v = axis(ax182);
axis(ax182,[v(1),100,-180,180]);

legend(ax181,{'$A=20$','$A=40$','$A=80$'},'interpreter','latex','location','best');
legend(ax182,{'$A=20$','$A=40$','$A=80$'},'interpreter','latex','location','best');

ylabel(ax181,'Amplitude (dB)');
ylabel(ax182,'Phase (deg)');
xlabel(ax182,'Frequency (Hz)');

% exporting data

f = bode_track{1}(1,:);
H18 = {'f','m1','p1','m2','p2','m3','p3'};
M18 = [f; bode_track{1}(2,:); bode_track{1}(3,:); ...
       bode_track{2}(2,:); bode_track{2}(3,:); ...
       bode_track{3}(2,:); bode_track{3}(3,:)];

fid18 = fopen(fig18_name,'w');
fprintf(fid18,'%s,%s,%s,%s,%s,%s,%s\n',H18{:});
fprintf(fid18,'%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M18);
fclose(fid18);

% eof
