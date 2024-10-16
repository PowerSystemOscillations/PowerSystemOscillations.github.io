%% fig 10.38

clear all; close all; clc;
load('d2aphvdcss.mat');

fig38_name = './dat/ch10_fig38.dat';

fig38 = figure;
ax381 = subplot(1,1,1,'parent',fig38);
hold(ax381,'on');
grid(ax381,'on');

eig_track = eig(a_mat);

plot(ax381,[0,-5],[0,5*tan(acos(0.05))],'k');
%plot(ax381,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax381,real(eig_track(:,1)),imag(eig_track(:,1)),'k+','lineWidth',0.75);
axis(ax381,[-20,5,0,10]);

ylabel(ax381,'Imaginary (rad/s)');
xlabel(ax381,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H38 = {'k','mag','ang','re','im'};
M38 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid38 = fopen(fig38_name,'w');
fprintf(fid38,'%s,%s,%s,%s,%s\n',H38{:});    % must match number of columns
fprintf(fid38,'%6e,%6e,%6e,%6e,%6e\n',M38);  % must match number of columns
fclose(fid38);

% eof
