% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.44

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');
load('../mat/dcpf1cont2.mat');                % damping control

%-------------------------------------%
% fig 44

fig44_name = './csv/ch10_fig44.csv';

fig44 = figure;
ax441 = subplot(1,1,1,'parent',fig44);
hold(ax441,'on');
grid(ax441,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:)-c_ang(9,:),d_angdcr(3,:)-d_angdcr(9,:));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);
sys_wo = tf([0.1,0],[0.1,1]);
s_cr = ss(s_cr.a,s_cr.b,s_cr.c,s_cr.d);

sys_dcr_rc = sys_dcr*rate*s_cr;

K = [0:0.1:10,11:24,25,50,1e2,1e3,1e4,1e5,1e6];
eig_track = zeros(size(sys_dcr_rc.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = eig(sys_dcr_rc.a + K(ii)*sys_dcr_rc.b*sys_dcr_rc.c);
    if ii < 100
        plot(ax441,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax441,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax441,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax441,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax441,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax441,[-3,3,0,8]);
xlabel(ax441,'Real (1/s)');
ylabel(ax441,'Imaginary (rad/s)');

% exporting data

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H44 = {'k','re','im'};
M44 = [1:length(rl_vec); real(rl_vec); imag(rl_vec)];

fid44 = fopen(fig44_name,'w');
fprintf(fid44,'%s,%s,%s\n',H44{:});
fprintf(fid44,'%6e,%6e,%6e\n',M44);
fclose(fid44);

% eof
