% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.38

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');

%-------------------------------------%
% fig 38

fig38_name = './csv/ch10_fig38.csv';

fig38 = figure;
ax381 = subplot(1,1,1,'parent',fig38);
hold(ax381,'on');
grid(ax381,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:),d_angdcr(3,:));  % bus 3
rate = tf([1 0],(2*pi*60)*[0.01 1]);
sys_dcr_htf = sys_dcr*rate;

[p_dcr,z_dcr] = pzmap(sys_dcr_htf);
p_dcr = p_dcr.';
z_dcr = z_dcr.';

plot(ax381,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax381,real(p_dcr),imag(p_dcr),'r+','lineWidth',0.75);
plot(ax381,real(z_dcr),imag(z_dcr),'bo','lineWidth',0.75);
axis(ax381,[-20,5,0,10]);

ylabel(ax381,'Imaginary (rad/s)');
xlabel(ax381,'Real (1/s)');

H38 = {'k','rep','imp','rez','imz'};
M38 = [1:1:length(p_dcr); real(p_dcr); imag(p_dcr); real(z_dcr); imag(z_dcr)];

fid38 = fopen(fig38_name,'w');
fprintf(fid38,'%s,%s,%s,%s,%s\n',H38{:});
fprintf(fid38,'%6e,%6e,%6e,%6e,%6e\n',M38);
fclose(fid38);

% eof
