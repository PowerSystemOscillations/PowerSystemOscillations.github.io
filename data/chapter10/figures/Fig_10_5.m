% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.5

% d2adcem1ss_no_svc.mat: 2-area test case post-fault condition 1
% d2adcem2ss_no_svc.mat: 2-area test case post-fault condition 2
% d2adcem3ss_no_svc.mat: 2-area test case post-fault condition 3

clear all; close all; clc;
load('../mat/d2adcem1ss_no_svc.mat');

%-------------------------------------%
% fig 5

fig5_name = './csv/ch10_fig5.csv';

fig5 = figure;
ax51 = subplot(1,1,1,'parent',fig5);
hold(ax51,'on');
grid(ax51,'on');

eig_track1 = eig(a_mat);

plot(ax51,[0,-5],[0,5*tan(acos(0.05))],'k');
h1 = plot(ax51,real(eig_track1(:,1)),imag(eig_track1(:,1)),'b+','lineWidth',0.75);

load('../mat/d2adcem2ss_no_svc.mat');

eig_track2 = eig(a_mat);
h2 = plot(ax51,real(eig_track2(:,1)),imag(eig_track2(:,1)),'rx','lineWidth',0.75);

load('../mat/d2adcem3ss_no_svc.mat');

eig_track3 = eig(a_mat);
h3 = plot(ax51,real(eig_track3(:,1)),imag(eig_track3(:,1)),'pentagram','lineWidth',0.75);

ylabel(ax51,'Imaginary (rad/s)');
xlabel(ax51,'Real');
axis(ax51,[-3,1,0,10]);

legend(ax51,[h1,h2,h3],{'post-fault 1','post-fault 2','post-fault 3'});

% exporting data file
rl_vec1 = reshape(eig_track1,[1,numel(eig_track1)]);
rl_vec2 = reshape(eig_track2,[1,numel(eig_track2)]);
rl_vec3 = reshape(eig_track3,[1,numel(eig_track3)]);

H5 = {'k','re1','im1','re2','im2','re3','im3'};
M5 = [1:1:length(rl_vec1); real(rl_vec1); imag(rl_vec1); ...
      real(rl_vec2); imag(rl_vec2); real(rl_vec3); imag(rl_vec3)];

fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s,%s,%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M5);
fclose(fid5);

% eof
