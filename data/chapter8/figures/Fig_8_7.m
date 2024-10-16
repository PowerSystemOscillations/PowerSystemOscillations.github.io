% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.7

% datalaag_smib_tor.mat:

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

%-------------------------------------%
% fig 7

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_spd = smib_tor.c_spd;

n = size(a_mat,1);

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

sys_speed_pss = ss(a_casc,b_casc,c_casc,0);

w02 = [1.024050e+02, 1.514296e+02, 1.904670e+02, 2.764385e+02].^2;
betaf = 1./w02;
alphaf = [0.005, 0.001, 0.0005, 0.0001];
gammaf = [5e-7, 5e-7, 5e-7, 5e-7];

btf = [betaf(1),gammaf(1),1];                 % numerator
atf = [betaf(1),alphaf(1),1];                 % denominator
for ii = 2:length(w02)
    btf = conv(btf,[betaf(ii),gammaf(ii),1]);
    atf = conv(atf,[betaf(ii),alphaf(ii),1]);
end

sys_tor_filt = tf(btf,atf);                   % torsional filter
sys_pss_tor_filt = series(sys_speed_pss,sys_tor_filt);

k = [0:1:150];
eig_track = zeros(size(sys_pss_tor_filt.A,1),length(k));
for ii = 1:length(k)
    dd = eig(sys_pss_tor_filt.A + k(ii)*sys_pss_tor_filt.B*sys_pss_tor_filt.C);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

filter_zeros = zeros(length(betaf),1);
for ii = 1:length(betaf)
    tmp = roots([betaf(ii),gammaf(ii),1]);
    filter_zeros(ii) = real(tmp(1));
end

fig7 = figure;
ax7 = subplot(1,1,1,'parent',fig7);
hold(ax7,'on');
grid(ax7,'on');

plot(ax7,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax7,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax7,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax7,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax7,[-2.5,1.0,0,10]);

% eof
