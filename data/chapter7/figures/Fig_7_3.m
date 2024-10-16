% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.3

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% fig 3

fig3_name = './csv/ch7_fig3.csv';

fig3 = figure;
ax3 = subplot(1,1,1,'parent',fig3);
hold(ax3,'on');
grid(ax3,'on');

k = linspace(0,100,101);
eig_track = zeros(10,length(k));
for ii = 1:length(k)
    dd = eig(a_mat + k(ii)*b_vr*c_spd);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:10);
end

plot(ax3,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax3,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax3,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax3,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax3,[-10,1,0,20]);

ylabel(ax3,'Imaginary (rad/s)');
xlabel(ax3,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H3 = {'k','mag','ang','re','im'};
M3 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid3 = fopen(fig3_name,'w');
fprintf(fid3,'%s,%s,%s,%s,%s\n',H3{:});
fprintf(fid3,'%6e,%6e,%6e,%6e,%6e\n',M3);
fclose(fid3);

% eof
