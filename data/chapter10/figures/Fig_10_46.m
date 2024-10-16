%% fig 10.46

clear all; close all; clc;
load('d2aphvdcss.mat');
load('dcpf1cont2.mat');

fig46_name = './dat/ch10_fig46.dat';

fig46 = figure;
ax461 = subplot(1,1,1,'parent',fig46);
hold(ax461,'on');
grid(ax461,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:)-c_ang(9,:),d_angdcr(3,:)-d_angdcr(9,:));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);
sys_wo = tf([0.1,0],[0.1,1]);
s_cr = ss(s_cr.a,s_cr.b,s_cr.c,s_cr.d);

sys_dcr_rc = sys_dcr*rate*s_cr;

K = [0:0.1:10,11:24,25,50,1e2,1e3,1e4,1e5,1e6];
eig_track = zeros(size(sys_dcr_rc.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = ...
            eig(sys_dcr_rc.a + K(ii)*sys_dcr_rc.b*sys_dcr_rc.c);
    if ii < length(K)
        plot(ax461,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax461,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax461,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax461,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax461,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax461,[-3,3,0,8]);
xlabel(ax461,'Real');
ylabel(ax461,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H46 = {'k','re','im'};
M46 = [1:length(rl_vec); real(rl_vec); imag(rl_vec)];

fid46 = fopen(fig46_name,'w');
fprintf(fid46,'%s,%s,%s\n',H46{:});  % must match number of columns
fprintf(fid46,'%6e,%6e,%6e\n',M46);  % must match number of columns
fclose(fid46);

% eof
