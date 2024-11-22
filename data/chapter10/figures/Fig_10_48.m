% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.48

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');
load('../mat/dcpf1cont2.mat');                % damping control

%-------------------------------------%
% fig 48

fig48_name = './csv/ch10_fig48.csv';

Fs = 30;                                      % sample rate
tt = 0:1/Fs:10;                               % time vector

% SISO model
sys_dcr = ss(a_mat,b_dcr(:,1),(c_ang(3,:)-c_ang(9,:)),(d_angdcr(3,:)-d_angdcr(9,:)));

rate = 2*pi*60*tf([1 0],(2*pi*60)*[0.01 1]);
c1_n = conv([1,0],conv([0.1,1],[0.1,1]));
c1_d = conv([1,1],conv([0.02,1],[0.02,1]));
sys_c1 = tf(c1_n,c1_d);
sys_wo = tf([0.1,0],[0.1,1]);

%sys_dcr_c1 = feedback(sys_dcr*rate,2*sys_c1,1,1,-1); % residue-based control

s_cr = ss(s_cr.a,s_cr.b,s_cr.c,s_cr.d);  % robust non-min phase controller
s_crmp = ss(s_crmp.a,s_crmp.b,s_crmp.c,s_crmp.d); % robust min phase controller
sys_dcr_rc = feedback(sys_dcr*rate*sys_wo,s_cr,1,1,1); % robust control fdbk system
eig_rob_cont = eig(sys_dcr_rc); % stable closed-loop eigenvalues
% check sign for stability
sys_coprime = inv(1-sys_dcr*rate*sys_wo*s_cr); %negative sign needed for stability
eig_coprime = eig(sys_coprime);  % stable; same eigenvalues as
zero_sys_coprime = tzero(sys_coprime);

% left normalized coprime factorization
% Joe's notes: the rate TF in series with the plant must have been part of
% the robust controller design. The poles and zeros of s_cr are given in
% Table 10.4 with one RHP zero (thus non-minimum phase)
% Thus the coprine factors have to include this rate TF.
[FACT,Ml,Nl] = lncf(sys_dcr*rate);
% eig_sys_dcr = eig(sys_dcr); % Same as eigenvalues of a_mat; system is OL unstable
% zero_sys_dcr = tzero(sys_dcr);
% figure, pzplot(s_cr),axis([-20, 5, 0 10]),
% figure, pzplot(sys_dcr), axis([-20 5 0 10]), grid

% figure, pzplot(sys_coprime), axis([-20 5 0 10]), grid
% eig_Ml_inv = eig(inv(Ml)); % inverse of M is unstable
eig_s_cr = eig(inv(1-sys_dcr*rate*s_cr));
%max(real(eig_s_cr))
Mbold = [s_cr; 1]*inv(1-sys_dcr*rate*s_cr)*inv(Ml); % stable

eig_Mbold = eig(Mbold);
%figure, pzplot(Mbold), axis([-20, 5, 0 10])
W = logspace(-2,2,1000);
[SV] = sigma(Mbold,W*2*pi);
%figure, loglog(W,10.^(SV/20)), xlabel('Frequency Hz'), ylabel('Maximum Singular Value')
%figure, loglog(W,SV), xlabel('Frequency Hz'), ylabel('Maximum Singular Value')
%axis([0.01 100 0.1 10]), grid
%figure, sigma(Mbold)

% Joe's notes: Based on the root-locus plot of Fig. 5.50, a gain of 3 needs
% to be used wiht s_crmp (min-phase controller); also change of sign. Also
% a washout sys_wo filter needs to be in the controller to compensate for
% the phase loss going from nonmin-phase to min-phase. sys_wo is with the
% controller, not the plant. Thus coprime factors remain the same.
eig_s_crmp = eig(inv(1+sys_dcr*rate*3*s_crmp*sys_wo));
%max(real(eig_s_crmp))
Mboldmp = [3*s_crmp*sys_wo; 1]*inv(1+sys_dcr*rate*3*s_crmp*sys_wo)*inv(Ml);
eig_Mboldmp = eig(Mboldmp);
%figure, pzplot(Mboldmp), axis([-20, 5, 0 10])
W = logspace(-2,2,1000);
[SVmp] = sigma(Mboldmp,W*2*pi);
%figure, loglog(W,10.^(SV/20)), xlabel('Frequency Hz'), ylabel('Maximum Singular Value')
%figure, loglog(W,SVmp), xlabel('Frequency Hz'), ylabel('Maximum Singular Value')
%axis([0.01 100 0.1 10]), grid
%figure, sigma(Mbold)

figure;
loglog(W,SVmp,'-',W,SV,'.');
xlabel('Frequency Hz');
ylabel('Maximum Singular Value');
legend('modified minimum phase control','non-minimum phase control');
axis([0.01 100 0.1 10]);
grid on;

%max(SV)
%max(SVmp)

H48 = {'f_sv','SVmp','SV'};
M48 = [W; SVmp(1,:); SV(1,:)];

fid48 = fopen(fig48_name,'w');
fprintf(fid48,'%s,%s,%s\n',H48{:});
fprintf(fid48,'%6e,%6e,%6e\n',M48);
fclose(fid48);

% Uncertainty bounds
% robust (non-minimum phase) controller - max SV is 2.2862 ==>
%      stability margin = 1/2.2862 = 0.4374 (Graham: SV 1.9, margin 50%)
% minimum phase controller - max SV is 3.2638
%      stability margin = 1/3.2638 = 0.3043 (Graham: SV 3.1, margin 32%)

% eof
