% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.14

% stexcss.mat: static exciter analysis

clear all; close all; clc;                    % reset workspace
load('../mat/stexcss.mat');                   % state-space model

%-------------------------------------%
% fig 14

fig14_name = './csv/ch6_fig14.csv';

fig14 = figure;
ax141 = subplot(1,1,1,'parent',fig14);
hold(ax141,'on');
grid(ax141,'on');

plot(ax141,real(rlstex),imag(rlstex),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax141,real(rlstex(:,1)),imag(rlstex(:,1)),'r+','lineWidth',0.75);
plot(ax141,real(rlstex(:,181)),imag(rlstex(:,181)),'rs','markerSize',8.5);
axis(ax141,[-10,2,0,40]);

xlabel(ax141,'Real');
ylabel(ax141,'Imaginary');

% exporting data file
rl_vec = reshape(rlstex,[1,numel(rlstex)]);

H14 = {'k','mag','ang','re','im'};
M14 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid14 = fopen(fig14_name,'w');
fprintf(fid14,'%s,%s,%s,%s,%s\n',H14{:});
fprintf(fid14,'%6e,%6e,%6e,%6e,%6e\n',M14);
fclose(fid14);

% eof
