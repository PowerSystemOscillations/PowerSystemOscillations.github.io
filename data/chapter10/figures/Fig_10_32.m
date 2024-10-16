%% fig 10.32

clear all; close all; clc;
load('d2atcscs.mat');

fig32_name = './dat/ch10_fig32.dat';

fig32 = figure;
ax321 = subplot(1,1,1,'parent',fig32);
hold(ax321,'on');
grid(ax321,'on');

sys_tcsc = ss(a_mat,b_tcsc(:,1),c_v(12,:),0);

cn = 100*conv([1,0],conv([0.1,1],[0.1,1]));
cd = conv([1,1],conv([0.05,1],conv([0.5,1],[0.5,1])));
sys_c1 = tf(cn,cd);

sys_tcsc_c1 = sys_tcsc*sys_c1;

K = [0:0.1:10,1000];
eig_track = zeros(size(sys_tcsc_c1.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = eig(sys_tcsc_c1.a - K(ii)*sys_tcsc_c1.b*sys_tcsc_c1.c);
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
