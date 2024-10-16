%% fig 10.41

clear all; close all; clc;
load('d2aphvdcss.mat');

fig41_name = './dat/ch10_fig41.dat';

fig41 = figure;
ax411 = subplot(1,1,1,'parent',fig41);
hold(ax411,'on');
grid(ax411,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:)-c_ang(9,:),d_angdcr(3,:)-d_angdcr(9,:));  % bus 3
rate = tf([1 0],(2*pi*60)*[0.01 1]);
sys_dcr_htf = sys_dcr*rate;

[p_dcr,z_dcr] = pzmap(sys_dcr_htf);

% padding for size consistency
p_dcr = p_dcr.';
z_dcr = z_dcr.';

plot(ax411,[0,-5],[0,5*tan(acos(0.05))],'k');
%plot(ax411,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax411,real(p_dcr),imag(p_dcr),'k+','lineWidth',0.75);
plot(ax411,real(z_dcr),imag(z_dcr),'ko','lineWidth',0.75);
axis(ax411,[-20,5,0,10]);

ylabel(ax411,'Imaginary (rad/s)');
xlabel(ax411,'Real');

H41 = {'k','rep','imp','rez','imz'};
M41 = [1:1:length(p_dcr); real(p_dcr); imag(p_dcr); real(z_dcr); imag(z_dcr)];

fid41 = fopen(fig41_name,'w');
fprintf(fid41,'%s,%s,%s,%s,%s\n',H41{:});
fprintf(fid41,'%6e,%6e,%6e,%6e,%6e\n',M41);
fclose(fid41);

% eof
