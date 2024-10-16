%% fig 10.40

clear all; close all; clc;
load('d2aphvdcss.mat');

fig40_name = './dat/ch10_fig40.dat';

fig40 = figure;
ax401 = subplot(1,1,1,'parent',fig40);
hold(ax401,'on');
grid(ax401,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:),d_angdcr(3,:));  % bus 3
rate = tf([1 0],(2*pi*60)*[0.01 1]);
sys_dcr_htf = sys_dcr*rate;

[p_dcr,z_dcr] = pzmap(sys_dcr_htf);
p_dcr = p_dcr.';
z_dcr = z_dcr.';

plot(ax401,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax401,real(p_dcr),imag(p_dcr),'k+','lineWidth',0.75);
plot(ax401,real(z_dcr),imag(z_dcr),'ko','lineWidth',0.75);
axis(ax401,[-20,5,0,10]);

ylabel(ax401,'Imaginary (rad/s)');
xlabel(ax401,'Real');

H40 = {'k','rep','imp','rez','imz'};
M40 = [1:1:length(p_dcr); real(p_dcr); imag(p_dcr); real(z_dcr); imag(z_dcr)];

fid40 = fopen(fig40_name,'w');
fprintf(fid40,'%s,%s,%s,%s,%s\n',H40{:});
fprintf(fid40,'%6e,%6e,%6e,%6e,%6e\n',M40);
fclose(fid40);

% eof
