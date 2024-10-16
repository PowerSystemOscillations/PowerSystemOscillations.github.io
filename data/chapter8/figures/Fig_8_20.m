% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.20

% datalam_stsp.mat: 4-generator infinite bus plant model, state-space

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

%-------------------------------------%
% fig 20

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(9:16,9:16);
c_spd = c_spd(2,9:16);
b_vr = b_vr(9:16,2);

n = size(a_mat,1);

fig20_name = './csv/ch8_fig20.csv';

fig20 = figure;
ax20 = subplot(1,1,1,'parent',fig20);
hold(ax20,'on');
grid(ax20,'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

exc_st = find(b_vr > 10);

% lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td1];
a_tmp1(exc_st,end) = b_vr(exc_st);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*b_vr(exc_st);
a_casc(n+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2]) = [(Tn1/Td1)*b_vr(exc_st); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax20,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax20,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax20,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax20,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax20,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax20,[-10,1.0,0,20]);

ylabel(ax20,'Imaginary (rad/s)');
xlabel(ax20,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H20 = {'k','mag','ang','re','im'};
M20 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid20 = fopen(fig20_name,'w');
fprintf(fid20,'%s,%s,%s,%s,%s\n',H20{:});
fprintf(fid20,'%6e,%6e,%6e,%6e,%6e\n',M20);
fclose(fid20);

% eof
