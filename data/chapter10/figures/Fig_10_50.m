%% fig 10.50

clear all; close all; clc;
load('d2aphvdcss.mat');
load('dcpf1cont2.mat');

fig50_name = './dat/ch10_fig50.dat';

fig50 = figure;
ax501 = subplot(1,1,1,'parent',fig50);
hold(ax501,'on');
grid(ax501,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:)-c_ang(9,:),d_angdcr(3,:)-d_angdcr(9,:));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);
sys_wo = tf([0.1,0],[0.1,1]);
s_crmp = ss(s_crmp.a,s_crmp.b,s_crmp.c,s_crmp.d);

sys_dcr_rc = -1*sys_dcr*rate*sys_wo*s_crmp;

K = [0:0.1:10,1e6];
eig_track = zeros(size(sys_dcr_rc.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = ...
            eig(sys_dcr_rc.a + K(ii)*sys_dcr_rc.b*sys_dcr_rc.c);
    if ii < length(K)
        plot(ax501,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax501,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 31)
        plot(ax501,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax501,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax501,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax501,[-8,1,0,8]);
xlabel(ax501,'Real');
ylabel(ax501,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H50 = {'k','re','im'};
M50 = [1:length(rl_vec); real(rl_vec); imag(rl_vec)];

fid50 = fopen(fig50_name,'w');
fprintf(fid50,'%s,%s,%s\n',H50{:});  % must match number of columns
fprintf(fid50,'%6e,%6e,%6e\n',M50);  % must match number of columns
fclose(fid50);

% eof
