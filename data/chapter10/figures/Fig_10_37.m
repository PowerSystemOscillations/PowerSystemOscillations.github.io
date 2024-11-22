% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.37

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');

%-------------------------------------%
% fig 37

fig37_name = './csv/ch10_fig37.csv';

fig37 = figure;
ax371 = subplot(1,1,1,'parent',fig37);
hold(ax371,'on');
grid(ax371,'on');

eig_track = eig(a_mat);

plot(ax371,[0,-5],[0,5*tan(acos(0.05))],'k');
ax371.ColorOrderIndex = 1;
%plot(ax371,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax371,real(eig_track(:,1)),imag(eig_track(:,1)),'+','lineWidth',1.5);
axis(ax371,[-20,5,0,10]);

ylabel(ax371,'Imaginary (rad/s)');
xlabel(ax371,'Real (1/s)');

% exporting data

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H37 = {'k','mag','ang','re','im'};
M37 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); ...
       real(rl_vec); imag(rl_vec)];

fid37 = fopen(fig37_name,'w');
fprintf(fid37,'%s,%s,%s,%s,%s\n',H37{:});
fprintf(fid37,'%6e,%6e,%6e,%6e,%6e\n',M37);
fclose(fid37);

% eof
