% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.9

% datalaag_smib_tor.mat: single-machine infinite bus model with torsional dynamics

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

%-------------------------------------%
% fig 9

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_p = smib_tor.c_p(1,:);

fig9_name = './csv/ch8_figs9_10.csv';

fig9 = figure;
ax9 = subplot(1,1,1,'parent',fig9);
hold(ax9,'on');
grid(ax9,'on');

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

plot(ax9,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax9,real(eig_track(:,1:40)),imag(eig_track(:,1:40)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax9,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax9,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax9,[-0.2,0.2,90,300]);

ylabel(ax9,'Imaginary (rad/s)');
xlabel(ax9,'Real (1/s)');

% exporting data file

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H9 = {'k','mag','ang','re','im'};
M9 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); ...
      real(rl_vec); imag(rl_vec)];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
