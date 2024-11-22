% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.47

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');
load('../mat/dcpf1cont2.mat');                % damping control

%-------------------------------------%
% fig 47

fig47_name = './csv/ch10_fig47.csv';

fig47 = figure;
ax471 = subplot(1,1,1,'parent',fig47);
hold(ax471,'on');
grid(ax471,'on');

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
        plot(ax471,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax471,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 31)
        plot(ax471,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax471,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax471,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax471,[-8,1,0,8]);
xlabel(ax471,'Real (1/s)');
ylabel(ax471,'Imaginary (rad/s)');

% exporting data

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H47 = {'k','re','im'};
M47 = [1:length(rl_vec); real(rl_vec); imag(rl_vec)];

fid47 = fopen(fig47_name,'w');
fprintf(fid47,'%s,%s,%s\n',H47{:});
fprintf(fid47,'%6e,%6e,%6e\n',M47);
fclose(fid47);

% eof
