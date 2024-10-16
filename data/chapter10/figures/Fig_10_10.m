% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.10

% d2adcem.mat: 2-area system with dc exciters and governors, base system

clear all; close all; clc;
load('../mat/d2adcem.mat');

%-------------------------------------%
% fig 10

fig10_name = './csv/ch10_fig10.csv';

fig10 = figure;
ax101 = subplot(1,1,1,'parent',fig10);
hold(ax101,'on');
grid(ax101,'on');

sys_sv3 = ss(a_mat,b_svc(:,1),c_ilmf(5,:),0);
sys_c1 = tf([1,0],conv([1,1],[10,1]));
% sys_c2 = tf([0.08,0,0],conv(conv([0.5,1],[0.4,1]),conv([0.5,1],[0.4,1])));
sys_sv3c1 = sys_sv3*sys_c1;  % svc at bus 3, control 1

K = 0:1:20;
eig_track = zeros(size(sys_sv3c1.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = eig(sys_sv3c1.a - K(ii)*sys_sv3c1.b*sys_sv3c1.c);
    plot(ax101,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
         'bd','markerFaceColor','b','markerSize',3.5);
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax101,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 6)
        plot(ax101,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax101,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax101,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax101,[-3,1,0,8]);
xlabel(ax101,'Real');
ylabel(ax101,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H10 = {'k','mag','ang','re','im'};
M10 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid10 = fopen(fig10_name,'w');
fprintf(fid10,'%s,%s,%s,%s,%s\n',H10{:});
fprintf(fid10,'%6e,%6e,%6e,%6e,%6e\n',M10);
fclose(fid10);

% eof
