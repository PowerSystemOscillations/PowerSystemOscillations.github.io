% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.2

% datalaag_smib_tor.mat: single-machine infinite bus model with torsional dynamics

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

%-------------------------------------%
% fig 2

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_spd = smib_tor.c_spd;

n = size(a_mat,1);

fig2_name = './csv/ch8_fig2.csv';

fig2 = figure;
ax2 = subplot(1,1,1,'parent',fig2);
hold(ax2,'on');
grid(ax2,'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

exc_st = find(b_vr > 10);

% lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd)), -1/Td1];
a_tmp1(exc_st,end) = b_vr(exc_st);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*b_vr(exc_st);
a_casc(n+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2]) = [(Tn1/Td1)*b_vr(exc_st); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = [0:1:99,logspace(2,4,200),1e9];
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax2,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax2,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax2,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax2,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',6.5);
plot(ax2,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax2,[-25,25,0,300]);
% axis(ax3,[-3.0,1.0,0,12]);

ylabel(ax2,'Imaginary (rad/s)');
xlabel(ax2,'Real (1/s)');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H2 = {'k','mag','ang','re','im'};
M2 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid2 = fopen(fig2_name,'w');
fprintf(fid2,'%s,%s,%s,%s,%s\n',H2{:});
fprintf(fid2,'%6e,%6e,%6e,%6e,%6e\n',M2);
fclose(fid2);

% eof
