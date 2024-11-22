% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.15

% d2adcem.mat: 2-area system with dc exciters, no svc,
%              d2adcem.m (state space)

clear all; close all; clc;
load('../mat/d2adcem.mat');
load('../mat/control.mat');                   % control specification

%-------------------------------------%
% fig 15

fig15_name = './csv/ch10_fig15.csv';

fig15 = figure;
ax151 = subplot(1,1,1,'parent',fig15);
hold(ax151,'on');
grid(ax151,'on');

sys_sv3 = ss(a_mat,b_svc(:,1),c_ilmf(5,:),0);

sc = ss(sc.a,sc.b,sc.c,sc.d);
scr = ss(scr.a,scr.b,scr.c,scr.d);
sys_c1 = sc*scr;

sys_sv3_c1r = sys_c1*sys_sv3;

K = 0:0.5:10;
eig_track = zeros(size(sys_sv3_c1r.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = ...
            eig(sys_sv3_c1r.a + K(ii)*sys_sv3_c1r.b*sys_sv3_c1r.c);
    plot(ax151,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
         'bd','markerFaceColor','b','markerSize',3.5);
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax151,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax151,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax151,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax151,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax151,[-3,1,0,8]);
xlabel(ax151,'Real (1/s)');
ylabel(ax151,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H15 = {'k','re','im'};
M15 = [1:length(rl_vec); real(rl_vec); imag(rl_vec)];

fid15 = fopen(fig15_name,'w');
fprintf(fid15,'%s,%s,%s\n',H15{:});
fprintf(fid15,'%6e,%6e,%6e\n',M15);
fclose(fid15);

% eof
