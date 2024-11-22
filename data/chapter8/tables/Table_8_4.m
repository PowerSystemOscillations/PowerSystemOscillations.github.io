% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 8.4

% datalaag_smib_tor.mat: single-machine infinite bus model with torsional dynamics

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

%-------------------------------------%
% table 4

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

btf = [betaf(1),gammaf(1),1];                 % torsional filter numerator
atf = [betaf(1),alphaf(1),1];                 % torsional filter denominator
for ii = 2:length(w02)
    btf = conv(btf,[betaf(ii),gammaf(ii),1]); % polynomial multiplication
    atf = conv(atf,[betaf(ii),alphaf(ii),1]); % polynomial multiplication
end

sys_tor_filt = tf(btf,atf);                   % torsional filter
sys_pss_tor_filt = series(sys_speed_pss,sys_tor_filt);

k = 0:1:11;
eig_track = zeros(size(sys_pss_tor_filt.A,1),length(k));
for ii = 1:length(k)
    dd = eig(sys_pss_tor_filt.A + k(ii)*sys_pss_tor_filt.B*sys_pss_tor_filt.C);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

mask = imag(eig_track(:,11)) >= 0;
d = eig_track(mask,11);
[~,d_ord] = sort(imag(d),'ascend');
d = d(d_ord);

fprintf('\nTable 4. Eigenvalues with a stabilizer gain of K=10.\n\n');
format short
fprintf('  %8.4f + j%8.4f    %8.4f   %8.4f\n', [real(d), imag(d), imag(d)/2/pi, round(-100*cos(angle(d)),1)].');

% eof
