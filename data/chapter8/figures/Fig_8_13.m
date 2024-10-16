% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.13

clear all; close all; clc;

%-------------------------------------%
% fig 13

H = 3.558;  % inertia constant

w = 2*pi*linspace(0,10,512);
H_F = tf([0.4,1],conv(conv(conv([0.1,1],[0.1,1]),[0.1,1]),[0.1,1]));
H_FP = (H_F - 1); % *tf([0,1],[2*H,0]);

[magH_F,phaseH_F,wH_F] = bode(H_F,w);
[magH_FP,phaseH_FP,wH_FP] = bode(H_FP,w);

fig13_name = './csv/ch8_fig13.csv';

fig13 = figure;
ax13{1} = subplot(2,1,1,'parent',fig13);
ax13{2} = subplot(2,1,2,'parent',fig13);
hold(ax13{1},'on');
hold(ax13{2},'on');

plot(ax13{1},wH_F/2/pi,squeeze(magH_F));
plot(ax13{1},wH_FP/2/pi,squeeze(magH_FP));
axis(ax13{1},[0,10,0,2]);

plot(ax13{2},wH_F/2/pi,wrapTo180(squeeze(phaseH_F)));
plot(ax13{2},wH_FP/2/pi,wrapTo180(squeeze(phaseH_FP)));
axis(ax13{2},[0,10,-200,200]);

ylabel(ax13{1},'Gain');
ylabel(ax13{2},'Phase (deg)');
xlabel(ax13{2},'Frequency (Hz)');

legend(ax13{1},{'speed part','power part'},'location','best');
legend(ax13{2},{'speed part','power part'},'location','best');

% exporting data file
H13 = {'f1','g1','gdb1','ph1','f2','g2','gdb2','ph2'};
M13 = [(wH_F/2/pi).'; squeeze(magH_F).'; (20*log10((squeeze(magH_F)))).'; wrapTo180(squeeze(phaseH_F)).';
       (wH_FP/2/pi).'; squeeze(magH_FP).'; (20*log10((squeeze(magH_FP)))).'; wrapTo180(squeeze(phaseH_FP)).'];

fid13 = fopen(fig13_name,'w');
fprintf(fid13,'%s,%s,%s,%s,%s,%s,%s,%s\n',H13{:});
fprintf(fid13,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M13);
fclose(fid13);

% eof
