% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.26

% 16mt1setgp.mat: 16-machine system, PSSs on all generators

clear all; close all; clc;
load('../mat/16mt1setgp.mat');

%-------------------------------------%
% fig 26

clear all; close all; clc;
load('../mat/16mt1setgp.mat');

fig26_name = './csv/ch7_fig26.csv';

fig26 = figure;
ax26 = subplot(1,1,1,'parent',fig26);
hold(ax26,'on');
grid(ax26,'on');

eig_track = eig(a_mat);

plot(ax26,[0,-5],[0,5*tan(acos(0.05))],'k');
%plot(ax26,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax26,real(eig_track(:,1)),imag(eig_track(:,1)),'k+','lineWidth',0.75);
axis(ax26,[-4,1,0,13]);

ylabel(ax26,'Imaginary (rad/s)');
xlabel(ax26,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H26 = {'k','mag','ang','re','im'};
M26 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid26 = fopen(fig26_name,'w');
fprintf(fid26,'%s,%s,%s,%s,%s\n',H26{:});
fprintf(fid26,'%6e,%6e,%6e,%6e,%6e\n',M26);
fclose(fid26);

% eof
