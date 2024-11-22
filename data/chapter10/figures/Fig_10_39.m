% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.39

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');

%-------------------------------------%
% fig 39

fig39_name = './csv/ch10_fig39.csv';

fig39 = figure;
ax391 = subplot(1,1,1,'parent',fig39);
hold(ax391,'on');
grid(ax391,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:)-c_ang(9,:),d_angdcr(3,:)-d_angdcr(9,:));
rate = tf([1 0],(2*pi*60)*[0.01 1]);
sys_dcr_htf = sys_dcr*rate;

[p_dcr,z_dcr] = pzmap(sys_dcr_htf);

% padding for size consistency
p_dcr = p_dcr.';
z_dcr = z_dcr.';

plot(ax391,[0,-5],[0,5*tan(acos(0.05))],'k');
%plot(ax391,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax391,real(p_dcr),imag(p_dcr),'r+','lineWidth',0.75);
plot(ax391,real(z_dcr),imag(z_dcr),'bo','lineWidth',0.75);
axis(ax391,[-20,5,0,10]);

ylabel(ax391,'Imaginary (rad/s)');
xlabel(ax391,'Real (1/s)');

H39 = {'k','rep','imp','rez','imz'};
M39 = [1:1:length(p_dcr); real(p_dcr); imag(p_dcr); real(z_dcr); imag(z_dcr)];

fid39 = fopen(fig39_name,'w');
fprintf(fid39,'%s,%s,%s,%s,%s\n',H39{:});
fprintf(fid39,'%6e,%6e,%6e,%6e,%6e\n',M39);
fclose(fid39);

% eof
