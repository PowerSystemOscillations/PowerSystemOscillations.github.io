% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.17

% d2adcem3.mat: 2-area system, one line each 3--101, 13--101
% control.mat: state-space control specification

clear all; close all; clc;
load('../mat/d2adcem3.mat');
load('../mat/control.mat');

%-------------------------------------%
% fig 17

fig17_name = './csv/ch10_fig17.csv';

fig17 = figure;
ax171 = subplot(2,1,1,'parent',fig17);
ax172 = subplot(2,1,2,'parent',fig17);
%
hold(ax171,'on');
hold(ax172,'on');
%
grid(ax171,'on');
grid(ax172,'on');

sys_sv3 = ss(a_mat,b_svc(:,1),c_ilmf(5,:),0);

sc = ss(sc.a,sc.b,sc.c,sc.d);
scr = ss(scr.a,scr.b,scr.c,scr.d);
sys_c1 = 5*sc*scr;

sc2 = ss(sc2.a,sc2.b,sc2.c,sc2.d);
scr2 = ss(scr2.a,scr2.b,scr2.c,scr2.d);
sys_c2 = 5*sc2*scr2;

sys_sv3_c1r = sys_c1*sys_sv3;
sys_sv3_c2r = sys_c2*sys_sv3;

eig_c1 = eig(sys_sv3_c1r.a + sys_sv3_c1r.b*sys_sv3_c1r.c);
eig_c2 = eig(sys_sv3_c2r.a + sys_sv3_c2r.b*sys_sv3_c2r.c);

plot(ax171,real(eig_c1),imag(eig_c1),'+','linewidth',1.5);
plot(ax171,[0,-5],[0,5*tan(acos(0.05))],'k');
axis(ax171,[-3,1,0,8]);

plot(ax172,real(eig_c2),imag(eig_c2),'+','linewidth',1.5);
plot(ax172,[0,-5],[0,5*tan(acos(0.05))],'k');
axis(ax172,[-3,1,0,8]);

ylabel(ax171,'Imag. (rad/s)');
ylabel(ax172,'Imag. (rad/s)');
xlabel(ax172,'Real');

H17 = {'mc1','ac1','rec1','imc1','mc2','ac2','rec2','imc2'};
M17 = [abs(eig_c1); (180/pi)*angle(eig_c1); real(eig_c1); imag(eig_c1); ...
       abs(eig_c2); (180/pi)*angle(eig_c2); real(eig_c2); imag(eig_c2)];

fid17 = fopen(fig17_name,'w');
fprintf(fid17,'%s,%s,%s,%s,%s,%s,%s,%s\n',H17{:});
fprintf(fid17,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M17);
fclose(fid17);

% eof
