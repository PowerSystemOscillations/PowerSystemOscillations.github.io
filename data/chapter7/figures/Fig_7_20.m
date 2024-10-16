% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.20

% 16mt3setgp16ss.mat: 16-machine system, PSSs on all gens except 1, 2

clear all; close all; clc;
load('../mat/16mt3setgp16ss.mat');

%-------------------------------------%
% fig 20

fig20_name = './csv/ch7_fig20.csv';

fig20 = figure;
ax20 = subplot(1,1,1,'parent',fig20);
hold(ax20,'on');
grid(ax20,'on');

eig_track = eig(a_mat);

plot(ax20,[0,-5],[0,5*tan(acos(0.05))],'k');
%plot(ax20,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax20,real(eig_track(:,1)),imag(eig_track(:,1)),'k+','lineWidth',0.75);
axis(ax20,[-4,1,0,13]);

ylabel(ax20,'Imaginary (rad/s)');
xlabel(ax20,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H20 = {'k','mag','ang','re','im'};
M20 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid20 = fopen(fig20_name,'w');
fprintf(fid20,'%s,%s,%s,%s,%s\n',H20{:});
fprintf(fid20,'%6e,%6e,%6e,%6e,%6e\n',M20);
fclose(fid20);

% eof
