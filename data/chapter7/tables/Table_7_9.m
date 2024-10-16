% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.9

% 16mt3setgp1ss.mat: 16-machine system, PSSs on all generators except 2

clear all; close all; clc;
load('../mat/16mt3setgp1ss.mat');

%-------------------------------------%
% table 9

% compensation parameters
Tw = 10;
Tn1 = 0.08;
Td1 = 0.01;
Tn2 = 0.08;
Td2 = 0.01;

g_idx = 2;
exc_st = find(b_vr(:,g_idx) > 10);

% second lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd(g_idx,:))), -1/Td2];
a_tmp1(exc_st,end) = 200/0.05;  % exciter gain divided by time constant

% first lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*(200/0.05);
a_tmp2(200,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,1)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*(200/0.05);
a_casc(200,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(201,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st,200,201,202]) = [(Tn1/Td1)*(Tn2/Td2)*(200/0.05),(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:199) = c_spd(g_idx,:);

k = linspace(0,10,11);
eig_track = zeros(202,length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:202);
end

mask = imag(eig_track(:,end)) > 2.5 & imag(eig_track(:,end)) < 12.5 ...
     & real(eig_track(:,end)) > -3;
[~,d_ord] = sort(imag(eig_track(mask,end)),'ascend');
d = eig_track(mask,end);
d = d(d_ord);

fprintf('\nTable 9.  Electromechanical modes with power system stabilizers.\n\n');
format short
disp(d);

fprintf('\nTable 9 cont. Frequency and damping.\n\n');
format short
disp([imag(d)/2/pi,round(-100*cos(angle(d)),1)]);

% eof
