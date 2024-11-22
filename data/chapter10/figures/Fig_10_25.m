% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.25

% d2atcscs.mat: 2-area test case dc exciters and tcsc control

clear all; close all; clc;
load('../mat/d2atcscs.mat');

%-------------------------------------%
% fig 25

fig25_name = './csv/ch10_fig25.csv';

fig25 = figure;
ax251 = subplot(1,1,1,'parent',fig25);
hold(ax251,'on');
grid(ax251,'on');

eig_track = eig(a_mat);

plot(ax251,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax251,real(eig_track(:,1)),imag(eig_track(:,1)),'b+','lineWidth',1.5);
axis(ax251,[-3,1,0,10]);

ylabel(ax251,'Imaginary (rad/s)');
xlabel(ax251,'Real (1/s)');

% exporting data

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H25 = {'k','mag','ang','re','im'};
M25 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); ...
       real(rl_vec); imag(rl_vec)];

fid25 = fopen(fig25_name,'w');
fprintf(fid25,'%s,%s,%s,%s,%s\n',H25{:});
fprintf(fid25,'%6e,%6e,%6e,%6e,%6e\n',M25);
fclose(fid25);

% eof
