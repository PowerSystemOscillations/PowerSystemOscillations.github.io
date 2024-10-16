% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.10

% d16mgdcetgibss.mat: 16-machine system, SMIB model for G16, dc exciter

clear all; close all; clc;
load('../mat/d16mgdcetgibss.mat');

%-------------------------------------%
% fig 10

fig10_name = './csv/ch7_fig10.csv';

fig10 = figure;
ax10 = subplot(1,1,1,'parent',fig10);
hold(ax10,'on');
grid(ax10,'on');

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

% plot(ax10,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax10,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax10,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax10,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax10,[-5,1,0,4]);

ylabel(ax10,'Imaginary (rad/s)');
xlabel(ax10,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H10 = {'k','mag','ang','re','im'};
M10 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid10 = fopen(fig10_name,'w');
fprintf(fid10,'%s,%s,%s,%s,%s\n',H10{:});
fprintf(fid10,'%6e,%6e,%6e,%6e,%6e\n',M10);
fclose(fid10);

% eof
