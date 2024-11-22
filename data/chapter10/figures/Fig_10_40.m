% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.40

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');

%-------------------------------------%
% fig 40

fig40_name = './csv/ch10_fig40.csv';

fig40 = figure;
ax401 = subplot(1,1,1,'parent',fig40);
hold(ax401,'on');
grid(ax401,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:),d_angdcr(3,:));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);

sys_dcr_rate = sys_dcr*rate;

K = [0:0.1:10,1e6];
eig_track = zeros(size(sys_dcr_rate.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = eig(sys_dcr_rate.a - K(ii)*sys_dcr_rate.b*sys_dcr_rate.c);
    if ii < length(K)
        plot(ax401,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax401,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax401,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax401,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax401,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax401,[-20,5,0,10]);
xlabel(ax401,'Real (1/s)');
ylabel(ax401,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H40 = {'k','mag','ang','re','im'};
M40 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid40 = fopen(fig40_name,'w');
fprintf(fid40,'%s,%s,%s,%s,%s\n',H40{:});
fprintf(fid40,'%6e,%6e,%6e,%6e,%6e\n',M40);
fclose(fid40);

% eof
