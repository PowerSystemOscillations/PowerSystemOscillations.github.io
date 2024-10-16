% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.7

% d2adcemss.mat: 2-area system with dc exciters and governors, base system

clear all; close all; clc;
load('../mat/d2adcemss.mat');

%-------------------------------------%
% fig 7

fig7_name = './csv/ch10_fig7.csv';

fig7 = figure;
ax71 = subplot(1,1,1,'parent',fig7);
hold(ax71,'on');
grid(ax71,'on');

sys3 = ss(a_mat,b_rlmod(:,1),c_v(3,:),0);
sys13 = ss(a_mat,b_rlmod(:,2),c_v(8,:),0);
sys101 = ss(a_mat,b_rlmod(:,3),c_v(11,:),0);

[p3,z3] = pzmap(sys3);
[p13,z13] = pzmap(sys13);
[p101,z101] = pzmap(sys101);

% padding for size consistency
p3 = p3.';
z3 = [z3.', -10];
z13 = [z13.', -10];
z101 = [z101.', -10];

plot(ax71,[0,-5],[0,5*tan(acos(0.05))],'k');
%plot(ax71,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax71,real(p3),imag(p3),'r+','lineWidth',0.75);
plot(ax71,real(z3),imag(z3),'bo','lineWidth',0.75);
plot(ax71,real(z13),imag(z13),'bo','lineWidth',0.75);
plot(ax71,real(z101),imag(z101),'bo','lineWidth',0.75);
axis(ax71,[-3,1,0,10]);

ylabel(ax71,'Imaginary (rad/s)');
xlabel(ax71,'Real');

H7 = {'k','rep','imp','rez3','imz3','rez13','imz13','rez101','imz101'};
M7 = [1:1:length(p3); real(p3); imag(p3); real(z3); imag(z3); ...
      real(z13); imag(z13); real(z101); imag(z101)];

fid7 = fopen(fig7_name,'w');
fprintf(fid7,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H7{:});
fprintf(fid7,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M7);
fclose(fid7);

% eof
