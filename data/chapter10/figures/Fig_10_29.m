% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.29

% d2atcscs.mat: 2-area test case dc exciters and tcsc control

clear all; close all; clc;
load('../mat/d2atcscs.mat');

%-------------------------------------%
% fig 29

fig29_name = './csv/ch10_fig29.csv';

fig29 = figure;
ax291 = subplot(1,1,1,'parent',fig29);
hold(ax291,'on');
grid(ax291,'on');

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
        plot(ax291,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax291,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax291,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax291,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax291,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax291,[-3,1,0,8]);
xlabel(ax291,'Real (1/s)');
ylabel(ax291,'Imaginary (rad/s)');

% exporting data

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H29 = {'k','mag','ang','re','im'};
M29 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid29 = fopen(fig29_name,'w');
fprintf(fid29,'%s,%s,%s,%s,%s\n',H29{:});
fprintf(fid29,'%6e,%6e,%6e,%6e,%6e\n',M29);
fclose(fid29);

% eof
