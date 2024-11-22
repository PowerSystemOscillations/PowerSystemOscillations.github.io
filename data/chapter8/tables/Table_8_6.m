% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 8.6

% datalam_stsp.mat: 4-generator infinite bus plant model, state-space

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

%-------------------------------------%
% table 6

tol = 1e-7;

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
a_mat(abs(a_mat) < tol) = 0;

a_mat_agg = a_mat(1:8,1:8);
a_mat_ip = a_mat(9:16,9:16);

d_ip = eig(a_mat_ip);
d_ip = d_ip(imag(d_ip) >= 0);
[~,d_ip_ord] = sort(imag(d_ip),'ascend');
d_ip = d_ip(d_ip_ord);

fprintf('\nState matrix of the intra-plant system.\n\n');
format short
fprintf('  %10.3f  %10.3f  %10.3f  %10.3f  %10.3f  %10.3f  %10.3f  %10.3f\n',a_mat_ip.');

fprintf('\nTable 6. Eigenvalues of the aggregate plant.\n\n');
format short
fprintf('    Eigenvalue             Frequency   Damping ratio\n');
fprintf('  %8.4f + j%7.4f    %8.4f    %8.4f\n', [real(d_ip), imag(d_ip), imag(d_ip)/2/pi, -cos(angle(d_ip))].');

% eof
