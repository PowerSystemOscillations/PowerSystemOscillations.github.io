% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.4

% sbfv.mat: root locus for residue analysis, d2asb.m

clear all; close all; clc;                    % reset workspace
load('../mat/sbfv.mat');                      % state-space model

%-------------------------------------%
% fig 4

fig4_name = './csv/ch4_fig4.csv';

fig4 = figure;
ax41 = subplot(1,1,1,'parent',fig4);
hold(ax41,'on');

for ii = 1:size(rl11,2)
    plot(ax41,real(rl11(:,ii)),imag(rl11(:,ii)),...
         'bd','markerFaceColor','b','markerSize',3.5);
end

plot(ax41,real(rl11(:,1)),imag(rl11(:,1)),'r+','lineWidth',0.75);
plot(ax41,real(rl11(:,end)),imag(rl11(:,end)),'ro');

axis(ax41,[-0.05,0.03,-0.01,0.01]);

xlabel(ax41,'real (1/s)');
ylabel(ax41,'imaginary (rad/s)');

rl_vec = reshape(rl11,[1,numel(rl11)]);

H4 = {'k','mag','ang','re','im'};
M4 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s,%s,%s\n',H4{:});
fprintf(fid4,'%6e,%6e,%6e,%6e,%6e\n',M4);
fclose(fid4);

% eof
