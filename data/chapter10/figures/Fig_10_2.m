% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.2

% d2adcemss.mat: 2-area system with dc exciters and svc control,
%                d2adcemss.m (state space)

clear all; close all; clc;
load('../mat/d2adcemss.mat');

%-------------------------------------%
% fig 2

fig2_name = './csv/ch10_fig2.csv';

fig2 = figure;
ax21 = subplot(1,1,1,'parent',fig2);
hold(ax21,'on');
grid(ax21,'on');

eig_track = eig(a_mat);

plot(ax21,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax21,real(eig_track(:,1)),imag(eig_track(:,1)),'k+','lineWidth',0.75);
axis(ax21,[-3,1,0,10]);

ylabel(ax21,'Imaginary (rad/s)');
xlabel(ax21,'Real (1/s)');

% exporting data

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H2 = {'k','mag','ang','re','im'};
M2 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid2 = fopen(fig2_name,'w');
fprintf(fid2,'%s,%s,%s,%s,%s\n',H2{:});    % must match number of columns
fprintf(fid2,'%6e,%6e,%6e,%6e,%6e\n',M2);  % must match number of columns
fclose(fid2);

% eof
