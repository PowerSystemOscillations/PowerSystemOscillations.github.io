% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.23

% datalam_stsp.mat: 4-generator infinite bus plant model, state-space

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

%-------------------------------------%
% fig 23

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

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

fig23_name = './csv/ch8_fig23.csv';

fig23 = figure;
ax23 = subplot(1,1,1,'parent',fig23);
hold(ax23,'on');
grid(ax23,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.05;
Td1 = 0.01;
Tn2 = 0.05;
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

plot(ax23,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax23,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax23,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax23,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax23,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax23,[-10,1.0,0,20]);

ylabel(ax23,'Imaginary (rad/s)');
xlabel(ax23,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H23 = {'k','mag','ang','re','im'};
M23 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid23 = fopen(fig23_name,'w');
fprintf(fid23,'%s,%s,%s,%s,%s\n',H23{:});
fprintf(fid23,'%6e,%6e,%6e,%6e,%6e\n',M23);
fclose(fid23);

% eof
