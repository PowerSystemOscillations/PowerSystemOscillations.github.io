% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.25

% datalam_stsp.mat: 4-generator infinite bus plant model, state-space

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

%-------------------------------------%
% fig 25

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(1:8,1:8);
c_spd = c_spd(1,1:8);
b_vr = b_vr(1:8,1);

n = size(a_mat,1);

fig25_name = './csv/ch8_fig25.csv';

fig25 = figure;
ax25 = subplot(1,1,1,'parent',fig25);
hold(ax25,'on');
grid(ax25,'on');

% compensation parameters
Tw = 5;
Tn1 = 0.10;
Td1 = 0.01;
Tn2 = 0.10;
Td2 = 0.01;

exc_st = find(b_vr > 10);

% second lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td2];
a_tmp1(exc_st,end) = b_vr(exc_st);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*b_vr(exc_st);
a_tmp2(n+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st);
a_casc(n+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2;n+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st), ...
                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax25,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax25,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax25,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax25,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax25,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax25,[-10,1.0,0,20]);

ylabel(ax25,'Imaginary (rad/s)');
xlabel(ax25,'Real (1/s)');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H25 = {'k','mag','ang','re','im'};
M25 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid25 = fopen(fig25_name,'w');
fprintf(fid25,'%s,%s,%s,%s,%s\n',H25{:});
fprintf(fid25,'%6e,%6e,%6e,%6e,%6e\n',M25);
fclose(fid25);

% eof
