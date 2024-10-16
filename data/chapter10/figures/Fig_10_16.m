% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.16

% d2adcem.mat: 2-area system with dc exciters and governors, base system
% control.mat: state-space control specification

clear all; close all; clc;
load('../mat/d2adcem.mat');
load('../mat/control.mat');

%-------------------------------------%
% fig 16

fig16_name = './csv/ch10_fig16.csv';

fig16 = figure;
ax161 = subplot(1,1,1,'parent',fig16);
hold(ax161,'on');
grid(ax161,'on');

sys_sv3 = ss(a_mat,b_svc(:,1),c_ilmf(5,:),0);

sc2 = ss(sc2.a,sc2.b,sc2.c,sc2.d);
scr2 = ss(scr2.a,scr2.b,scr2.c,scr2.d);
sys_c2 = sc2*scr2;

sys_sv3_c2r = sys_c2*sys_sv3;

K = 0:0.5:10;
eig_track = zeros(size(sys_sv3_c2r.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = ...
            eig(sys_sv3_c2r.a + K(ii)*sys_sv3_c2r.b*sys_sv3_c2r.c);
    plot(ax161,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
         'bd','markerFaceColor','b','markerSize',3.5);
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax161,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax161,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax161,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax161,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax161,[-3,1,0,8]);
xlabel(ax161,'Real');
ylabel(ax161,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H16 = {'k','re','im'};
M16 = [1:length(rl_vec); real(rl_vec); imag(rl_vec)];

fid16 = fopen(fig16_name,'w');
fprintf(fid16,'%s,%s,%s\n',H16{:});  % must match number of columns
fprintf(fid16,'%6e,%6e,%6e\n',M16);  % must match number of columns
fclose(fid16);

% eof
