% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.10

% datalaag_smib_tor.mat: single-machine infinite bus model with torsional dynamics

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

%-------------------------------------%
% fig 10

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_p = smib_tor.c_p(1,:);

fig10 = figure;
ax10 = subplot(1,1,1,'parent',fig10);
hold(ax10,'on');
grid(ax10,'on');

H = 3.558;                                    % inertia constant

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

Hpss = tf([Tw,0],[Tw,1])*tf([Tn1,1],[Td1,1]);
Gp = ss(a_mat,b_vr,c_p,0);
Gp = series(Gp,[tf([0,1],[1,0])]);
Gpss = series(Hpss,Gp);

k = 0:1:150;
eig_track = zeros(size(Gpss.A,1),length(k));
for ii = 1:length(k)
    dd = eig(Gpss.A - (k(ii)/(2*H))*Gpss.B*Gpss.C);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

% plotting

plot(ax10,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax10,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax10,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax10,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
% axis(ax10,[-25,25,0,300]);
axis(ax10,[-2.5,1.0,0,10]);

ylabel(ax10,'Imaginary (rad/s)');
xlabel(ax10,'Real (1/s)');

% eof
