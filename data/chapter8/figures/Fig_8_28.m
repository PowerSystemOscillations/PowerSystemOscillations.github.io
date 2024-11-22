% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.28

% datalam_stsp.mat: 4-generator infinite bus plant model, state-space

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

%-------------------------------------%
% fig 28

fig281_name = './csv/ch8_fig28_1.csv';
fig282_name = './csv/ch8_fig28_2.csv';
fig283_name = './csv/ch8_fig28_3.csv';
fig284_name = './csv/ch8_fig28_4.csv';

fig28 = figure;
ax281 = subplot(2,2,1,'parent',fig28);
ax282 = subplot(2,2,2,'parent',fig28);
ax283 = subplot(2,2,3,'parent',fig28);
ax284 = subplot(2,2,4,'parent',fig28);
%
hold(ax281,'on');
hold(ax282,'on');
hold(ax283,'on');
hold(ax284,'on');
%
grid(ax281,'on');
grid(ax282,'on');
grid(ax283,'on');
grid(ax284,'on');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_ang = c_ang*P;
b_vr = P\b_vr;

a_mat_agg = a_mat(1:8,1:8);
c_ang_agg = c_ang(6,1:8);
b_vr_agg = b_vr(1:8,1);

a_mat_ip = a_mat(9:16,9:16);
c_ang_ip = c_ang(6,9:16);
b_vr_ip = b_vr(9:16,2);

n_agg = size(a_mat_agg,1);
exc_st_agg = find(b_vr_agg > 10);

n_ip = size(a_mat_ip,1);
exc_st_ip = find(b_vr_ip > 10);

% subplot 1 aggregate

% stabilizer 1 parameters
Tw = 1.41;
Tf = 0.01;
Tn1 = 0.154;
Td1 = 0.033;

% first lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_ang_agg,2)), -1/Td1];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% washout
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_tmp2(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tf];
a_casc(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_agg+2,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3]) = ...
        [(1/Tf)*(Tn1/Td1)*b_vr_agg(exc_st_agg), ...
         (1/Tf)*(1 - Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_agg,2)) = c_ang_agg;

k = (0:0.1:10)/(2*pi*60);
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax281,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax281,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax281,[-60,20,0,50]);

% subplot 1 intra-plant

% first lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_ang_ip,2)), -1/Td1];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% washout
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_tmp2(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tf];
a_casc(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_ip+2,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3]) = ...
        [(1/Tf)*(Tn1/Td1)*b_vr_ip(exc_st_ip), ...
         (1/Tf)*(1 - Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_ip,2)) = c_ang_ip;

k = (0:0.1:10)/(2*pi*60);
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax281,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax281,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax281,[-60,20,0,50]);

ylabel(ax281,'Imaginary (rad/s)');
xlabel(ax281,'Real (1/s)');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H281 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M281 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid281 = fopen(fig281_name,'w');
fprintf(fid281,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H281{:});
fprintf(fid281,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M281);
fclose(fid281);

% subplot 2 aggregate

% stabilizer 2 parameters
Tw = 1.41;
Tf = 0.01;
Tn1 = 0.4;
Td1 = 0.3;

% first lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_ang_agg,2)), -1/Td1];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% washout
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_tmp2(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tf];
a_casc(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_agg+2,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3]) = ...
        [(1/Tf)*(Tn1/Td1)*b_vr_agg(exc_st_agg), ...
         (1/Tf)*(1 - Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_agg,2)) = c_ang_agg;

k = (0:0.1:10)/(2*pi*60);
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax282,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax282,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax282,[-60,20,0,50]);

% subplot 2 intra-plant

% first lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_ang_ip,2)), -1/Td1];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% washout
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_tmp2(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tf];
a_casc(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_ip+2,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3]) = ...
        [(1/Tf)*(Tn1/Td1)*b_vr_ip(exc_st_ip), ...
         (1/Tf)*(1 - Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_ip,2)) = c_ang_ip;

k = (0:0.1:10)/(2*pi*60);
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax282,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax282,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax282,[-60,20,0,50]);

ylabel(ax282,'Imaginary (rad/s)');
xlabel(ax282,'Real (1/s)');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H282 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M282 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid282 = fopen(fig282_name,'w');
fprintf(fid282,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H282{:});
fprintf(fid282,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M282);
fclose(fid282);

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H282 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M282 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid282 = fopen(fig282_name,'w');
fprintf(fid282,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H282{:});
fprintf(fid282,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M282);
fclose(fid282);

% subplot 3 aggregate

% stabilizer 3 parameters
Tw = 10;
Tf = 0.01;
Tn1 = 0.05;
Td1 = 0.01;
Tn2 = 0.05;
Td2 = 0.01;

% second lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_ang_agg,2)), -1/Td2];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_agg,end) = (Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_tmp3 = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_tmp3(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp3(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_tmp3(n_agg+2,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp3, zeros(size(a_tmp3,1),1); zeros(1,size(a_tmp3,2)), -1/Tf];
a_casc(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_agg+2,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_agg+3,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3;n_agg+4]) = ...
        [(1/Tf)*(Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg), ...
         (1/Tf)*(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
         (1/Tf)*(1-Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_agg,2)) = c_ang_agg;

k = (0:0.1:10)/(2*pi*60);
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax283,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax283,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax283,[-60,20,0,50]);

% subplot 3 intra-plant

% second lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_ang_ip,2)), -1/Td2];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_ip,end) = (Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_tmp3 = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_tmp3(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp3(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_tmp3(n_ip+2,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp3, zeros(size(a_tmp3,1),1); zeros(1,size(a_tmp3,2)), -1/Tf];
a_casc(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_ip+2,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_ip+3,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3;n_ip+4]) = ...
        [(1/Tf)*(Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip), ...
         (1/Tf)*(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
         (1/Tf)*(1-Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_ip,2)) = c_ang_ip;

k = (0:0.1:10)/(2*pi*60);
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

% filtering out neglected locus
mask = (real(eig_track_ip) < -20) & (abs(imag(eig_track_ip)) > 20);
mask = mask | (real(eig_track_ip) < -60);
eig_track_ip(mask) = -90;

% plotting
plot(ax283,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax283,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax283,[-60,20,0,50]);

ylabel(ax283,'Imaginary (rad/s)');
xlabel(ax283,'Real (1/s)');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H283 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M283 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid283 = fopen(fig283_name,'w');
fprintf(fid283,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H283{:});
fprintf(fid283,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M283);
fclose(fid283);

% subplot 4 aggregate

% stabilizer 4 parameters
Tw = 5;
Tf = 0.01;
Tn1 = 0.10;
Td1 = 0.01;
Tn2 = 0.10;
Td2 = 0.01;

% second lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_ang_agg,2)), -1/Td2];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_agg,end) = (Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_tmp3 = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_tmp3(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp3(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_tmp3(n_agg+2,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp3, zeros(size(a_tmp3,1),1); zeros(1,size(a_tmp3,2)), -1/Tf];
a_casc(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_agg+2,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_agg+3,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3;n_agg+4]) = ...
        [(1/Tf)*(Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg), ...
         (1/Tf)*(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
         (1/Tf)*(1-Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_agg,2)) = c_ang_agg;

k = (0:0.1:10)/(2*pi*60);
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax284,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax284,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax284,[-60,20,0,50]);

% subplot 4 intra-plant

% second lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_ang_ip,2)), -1/Td2];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_ip,end) = (Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_tmp3 = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_tmp3(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp3(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_tmp3(n_ip+2,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp3, zeros(size(a_tmp3,1),1); zeros(1,size(a_tmp3,2)), -1/Tf];
a_casc(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_ip+2,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_ip+3,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3;n_ip+4]) = ...
        [(1/Tf)*(Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip), ...
         (1/Tf)*(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
         (1/Tf)*(1-Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_ip,2)) = c_ang_ip;

k = (0:0.1:10)/(2*pi*60);
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

% filtering out neglected locus
mask = (real(eig_track_ip) < -20) & (abs(imag(eig_track_ip)) > 20);
mask = mask | (real(eig_track_ip) < -60);
eig_track_ip(mask) = -90;

% plotting
plot(ax284,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax284,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax284,[-60,20,0,50]);

ylabel(ax284,'Imaginary (rad/s)');
xlabel(ax284,'Real (1/s)');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H284 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M284 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid284 = fopen(fig284_name,'w');
fprintf(fid284,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H284{:});
fprintf(fid284,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M284);
fclose(fid284);

% eof
