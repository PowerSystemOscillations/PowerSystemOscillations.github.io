%% fig 10.32

clear all; close all; clc;
load('d2aphvdcss.mat');

fig32_name = './dat/ch10_fig32.dat';

fig32 = figure;
ax321 = subplot(1,1,1,'parent',fig32);
hold(ax321,'on');
grid(ax321,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),(c_ang(3,:)-c_ang(9,:)),(d_angdcr(3,:)-d_angdcr(9,:)));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);
c1_n = conv([1,0],conv([0.1,1],[0.1,1]));
c1_d = conv([1,1],conv([0.02,1],[0.02,1]));
sys_c1 = tf(c1_n,c1_d);

sys_dcr_rate = sys_dcr*sys_c1*rate;

K = [0:0.1:10,1000];
eig_track = zeros(size(sys_dcr_rate.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = eig(sys_dcr_rate.a - K(ii)*sys_dcr_rate.b*sys_dcr_rate.c);
    if ii < length(K)
        plot(ax321,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax321,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax321,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    elseif (ii == 21)
        plot(ax321,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rd','markerSize',7.0);         
    end
end

plot(ax321,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax321,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax321,[-3,1,0,8]);
xlabel(ax321,'Real');
ylabel(ax321,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H32 = {'k','mag','ang','re','im'};
M32 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid32 = fopen(fig32_name,'w');
fprintf(fid32,'%s,%s,%s,%s,%s\n',H32{:});    % must match number of columns
fprintf(fid32,'%6e,%6e,%6e,%6e,%6e\n',M32);  % must match number of columns
fclose(fid32);

% eof
