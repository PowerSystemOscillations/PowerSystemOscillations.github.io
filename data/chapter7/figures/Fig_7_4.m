% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.4

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% fig 4

fig4_name = './csv/ch7_fig4.csv';

fig4 = figure;
ax4 = subplot(1,1,1,'parent',fig4);
hold(ax4,'on');
grid(ax4,'on');

% cascading the system with the washout filter
T1 = 10;  % washout time constant

a_casc = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd)), -1/T1];
a_casc(7,end) = 200/0.05;
b_casc = [b_vr; -1/T1];
c_casc = [c_spd, 0];

k = linspace(0,100,101);
eig_track = zeros(10,length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:10);
end

plot(ax4,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax4,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax4,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax4,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax4,[-10,1,0,20]);

ylabel(ax4,'Imaginary (rad/s)');
xlabel(ax4,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H4 = {'k','mag','ang','re','im'};
M4 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s,%s,%s\n',H4{:});
fprintf(fid4,'%6e,%6e,%6e,%6e,%6e\n',M4);
fclose(fid4);

% eof
