% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.2

% hydrotss.mat: hydro governor root locus

clear all; close all; clc;                    % reset workspace
load('../mat/hydrotss.mat');                  % state-space model

%-------------------------------------%
% fig 2

fig2_name = './csv/ch6_fig2.csv';

fig2 = figure;
ax21 = subplot(1,1,1,'parent',fig2);
hold(ax21,'on');

plot(ax21,real(rlhg4g),imag(rlhg4g),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax21,real(rlhg4g(:,1)),imag(rlhg4g(:,1)),'r+','lineWidth',0.75);
plot(ax21,real(rlhg4g(:,5)),imag(rlhg4g(:,5)),'rs','markerSize',8.5);

v = axis(ax21);
axis(ax21,[-10,2,0,2.5]);

xlabel(ax21,'Real');
ylabel(ax21,'Imaginary (rad/s)');

% exporting data file
rl_vec = reshape(rlhg4g,[1,numel(rlhg4g)]);

H2 = {'k','mag','ang','re','im'};
M2 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid2 = fopen(fig2_name,'w');
fprintf(fid2,'%s,%s,%s,%s,%s\n',H2{:});
fprintf(fid2,'%6e,%6e,%6e,%6e,%6e\n',M2);
fclose(fid2);

% eof
