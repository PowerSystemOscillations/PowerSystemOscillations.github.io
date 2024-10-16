%% fig 10.35

clear all; close all; clc;
load('d2atcscs.mat');
load('control6.mat');

fig35_name = './dat/ch10_fig35.dat';

fig35 = figure;
ax351 = subplot(1,1,1,'parent',fig35);
hold(ax351,'on');
grid(ax351,'on');

sys_tcsc = ss(a_mat,b_tcsc(:,1),c_v(12,:),0);
% [sys_tcsc_red,~] = balred(sys_tcsc,8);  % remove negligible states

sc3 = ss(sc3.a,sc3.b,sc3.c,sc3.d);
scr = ss(scr.a,scr.b,scr.c,scr.d);
sys_rc = 100*sc3*scr;

sys_tcsc_rc = sys_rc*sys_tcsc;

K = [0:0.1:10,1e6];
eig_track = zeros(size(sys_tcsc_rc.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = ...
            eig(sys_tcsc_rc.a + K(ii)*sys_tcsc_rc.b*sys_tcsc_rc.c);
    if ii < length(K)
        plot(ax351,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax351,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax351,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax351,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax351,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax351,[-3,1,0,8]);
xlabel(ax351,'Real');
ylabel(ax351,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H35 = {'k','re','im'};
M35 = [1:length(rl_vec); real(rl_vec); imag(rl_vec)];

fid35 = fopen(fig35_name,'w');
fprintf(fid35,'%s,%s,%s\n',H35{:});  % must match number of columns
fprintf(fid35,'%6e,%6e,%6e\n',M35);  % must match number of columns
fclose(fid35);

% eof
