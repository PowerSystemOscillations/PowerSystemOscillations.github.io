% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.27

% datalam_stsp.mat: 4-generator infinite bus plant model, state-space

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

%-------------------------------------%
% fig 27

fig271_name = './csv/ch8_fig27_1.csv';
fig272_name = './csv/ch8_fig27_2.csv';
fig273_name = './csv/ch8_fig27_3.csv';
fig274_name = './csv/ch8_fig27_4.csv';

fig27 = figure;
ax271 = subplot(2,2,1,'parent',fig27);
ax272 = subplot(2,2,2,'parent',fig27);
ax273 = subplot(2,2,3,'parent',fig27);
ax274 = subplot(2,2,4,'parent',fig27);
%
hold(ax271,'on');
hold(ax272,'on');
hold(ax273,'on');
hold(ax274,'on');
%
grid(ax271,'on');
grid(ax272,'on');
grid(ax273,'on');
grid(ax274,'on');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat_agg = a_mat(1:8,1:8);
c_spd_agg = c_spd(1,1:8);
b_vr_agg = b_vr(1:8,1);

a_mat_ip = a_mat(9:16,9:16);
c_spd_ip = c_spd(2,9:16);
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

% lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_spd_agg,2)), -1/Td1];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2]) = [(Tn1/Td1)*b_vr_agg(exc_st_agg); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_agg,2)) = c_spd_agg;

k = 0:0.1:10;
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax271,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax271,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax271,[-60,2,0,20]);

% subplot 1 intra-plant

% lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_spd_ip,2)), -1/Td1];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2]) = [(Tn1/Td1)*b_vr_ip(exc_st_ip); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_ip,2)) = c_spd_ip;

k = 0:0.1:10;
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax271,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax271,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax271,[-60,2,0,20]);

ylabel(ax271,'Imaginary (rad/s)');
xlabel(ax271,'Real (1/s)');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H271 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M271 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid271 = fopen(fig271_name,'w');
fprintf(fid271,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H271{:});
fprintf(fid271,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M271);
fclose(fid271);

% subplot 2 aggregate

% stabilizer 2 parameters
Tw = 1.41;
Tf = 0.01;
Tn1 = 0.4;
Td1 = 0.3;

% lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_spd_agg,2)), -1/Td1];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2]) = [(Tn1/Td1)*b_vr_agg(exc_st_agg); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_agg,2)) = c_spd_agg;

k = 0:0.1:10;
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax272,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax272,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax272,[-60,20,0,50]);

% subplot 2 intra-plant

% lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_spd_ip,2)), -1/Td1];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2]) = [(Tn1/Td1)*b_vr_ip(exc_st_ip); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_ip,2)) = c_spd_ip;

k = 0:0.1:10;
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax272,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax272,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax272,[-60,2,0,20]);

ylabel(ax272,'Imaginary (rad/s)');
xlabel(ax272,'Real (1/s)');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H272 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M272 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid272 = fopen(fig272_name,'w');
fprintf(fid272,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H272{:});
fprintf(fid272,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M272);
fclose(fid272);

% subplot 3 aggregate

% stabilizer 3 parameters
Tw = 10;
Tf = 0.01;
Tn1 = 0.05;
Td1 = 0.01;
Tn2 = 0.05;
Td2 = 0.01;

% second lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_spd_agg,2)), -1/Td2];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_agg,end) = (Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_agg+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg), ...
                                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                                (1-Tn1/Td1)/Td1, -1/Tw];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_agg,2)) = c_spd_agg;

k = 0:0.1:10;
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax273,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax273,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax273,[-60,1,0,20]);

% subplot 3 intra-plant

% second lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_spd_ip,2)), -1/Td2];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_ip,end) = (Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_ip+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip), ...
                                            (Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                            (1-Tn1/Td1)/Td1, -1/Tw];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_ip,2)) = c_spd_ip;

k = 0:0.1:10;
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax273,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax273,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax273,[-60,1,0,20]);

ylabel(ax273,'Imaginary (rad/s)');
xlabel(ax273,'Real (1/s)');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H273 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M273 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid273 = fopen(fig273_name,'w');
fprintf(fid273,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H273{:});
fprintf(fid273,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M273);
fclose(fid273);

% subplot 4 aggregate

% stabilizer 4 parameters
Tw = 5;
Tf = 0.01;
Tn1 = 0.10;
Td1 = 0.01;
Tn2 = 0.10;
Td2 = 0.01;
%
% second lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_spd_agg,2)), -1/Td2];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_agg,end) = (Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_agg+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg), ...
                                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                                (1-Tn1/Td1)/Td1, -1/Tw];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_agg,2)) = c_spd_agg;

k = 0:0.1:10;
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax274,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax274,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax274,[-60,1,0,20]);

% subplot 4 intra-plant

% second lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_spd_ip,2)), -1/Td2];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_ip,end) = (Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_ip+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip), ...
                                            (Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                            (1-Tn1/Td1)/Td1, -1/Tw];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_ip,2)) = c_spd_ip;

k = 0:0.1:10;
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax274,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax274,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax274,[-60,1,0,20]);

ylabel(ax274,'Imaginary (rad/s)');
xlabel(ax274,'Real (1/s)');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H274 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M274 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid274 = fopen(fig274_name,'w');
fprintf(fid274,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H274{:});
fprintf(fid274,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M274);
fclose(fid274);

% eof
