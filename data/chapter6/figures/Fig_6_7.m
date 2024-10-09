% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.7

% dcexcss.mat: dc exciter analysis

clear all; close all; clc;                    % reset workspace
load('../mat/dcexcss.mat');                   % state-space model

%-------------------------------------%
% fig 7

fig7_name = './csv/ch6_fig7.csv';

fig7 = figure;
ax71 = subplot(1,1,1,'parent',fig7);
hold(ax71,'on');
grid(ax71,'on');

plot(ax71,real(rldcexc),imag(rldcexc),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax71,real(rldcexc(:,106)),imag(rldcexc(:,106)),'rs','markerSize',8.5);
axis(ax71,[-1,1,0,5]);

xlabel(ax71,'Real');
ylabel(ax71,'Imaginary');

% exporting data file
rl_vec = reshape(rldcexc,[1,numel(rldcexc)]);

H7 = {'k','mag','ang','re','im'};
M7 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid7 = fopen(fig7_name,'w');
fprintf(fid7,'%s,%s,%s,%s,%s\n',H7{:});
fprintf(fid7,'%6e,%6e,%6e,%6e,%6e\n',M7);
fclose(fid7);

% eof
