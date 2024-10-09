% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.9

% dcexcss.mat: dc exciter analysis

clear all; close all; clc;                    % reset workspace
load('../mat/dcexcss.mat');                   % state-space model

%-------------------------------------%
% fig 9

clear all; close all; clc;                    % reset workspace
load('../mat/dcexcss.mat');                   % state-space model

fig9_name = './csv/ch6_fig9.csv';

fig9 = figure;
ax91 = subplot(1,1,1,'parent',fig9);
hold(ax91,'on');
grid(ax91,'on');

plot(ax91,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax91,real(rlrfb),imag(rlrfb),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax91,real(rlrfb(:,1)),imag(rlrfb(:,1)),'r+','lineWidth',0.75);
plot(ax91,real(rlrfb(:,11)),imag(rlrfb(:,11)),'rs','markerSize',8.5);
axis(ax91,[-20,5,0,20]);

xlabel(ax91,'Real (1/s)');
ylabel(ax91,'Imaginary (rad/s)');

% exporting data file
rl_vec = reshape(rlrfb,[1,numel(rlrfb)]);

H9 = {'k','mag','ang','re','im'};
M9 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
