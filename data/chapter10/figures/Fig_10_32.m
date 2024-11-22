% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.32

% d2atcscs.mat: 2-area test case dc exciters and tcsc control

clear all; close all; clc;
load('../mat/d2atcscs.mat');
load('../mat/control6.mat');                  % tcsc control

%-------------------------------------%
% fig 32

fig32_name = './csv/ch10_fig32.csv';

fig32 = figure;
ax321 = subplot(1,1,1,'parent',fig32);
hold(ax321,'on');
grid(ax321,'on');

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
xlabel(ax321,'Real (1/s)');
ylabel(ax321,'Imaginary (rad/s)');

% exporting data

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H32 = {'k','re','im'};
M32 = [1:length(rl_vec); real(rl_vec); imag(rl_vec)];

fid32 = fopen(fig32_name,'w');
fprintf(fid32,'%s,%s,%s\n',H32{:});
fprintf(fid32,'%6e,%6e,%6e\n',M32);
fclose(fid32);

% eof
