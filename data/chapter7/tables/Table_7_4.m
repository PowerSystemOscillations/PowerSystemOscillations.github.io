% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.4

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% table 4

tol = 1e-7;

% compensation parameters
Tw = 10;
Tn1 = 0.03;
Td1 = 0.01;
Tn2 = 0.04;
Td2 = 0.01;

n = size(a_mat,1);
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

k = 10;
dd = eig(a_casc + k*b_casc*c_casc);
[~,d_ord] = sort(dd,'ascend');
dd = dd(d_ord);

fprintf('\nTable 4. Eigenvalues of the aggregate plant model.\n\n');
format short
disp(dd(1:end-1));
disp(dd(end));

fprintf('\nTable 4. Frequency and damping.\n\n');
format short
disp([imag(dd)/2/pi,-cos(angle(dd))]);

% eof
