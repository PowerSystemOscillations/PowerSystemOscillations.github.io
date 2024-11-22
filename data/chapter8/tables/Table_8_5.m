% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 8.5

% datalam_stsp.mat: 4-generator infinite bus plant model, state-space

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

%-------------------------------------%
% table 5

tol = 1e-7;

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
a_mat(abs(a_mat) < tol) = 0;

a_mat_agg = a_mat(1:8,1:8);
a_mat_ip = a_mat(9:16,9:16);

d_agg = eig(a_mat_agg);
d_agg = d_agg(imag(d_agg) >= 0);
[~,d_agg_ord] = sort(imag(d_agg),'ascend');
d_agg = d_agg(d_agg_ord);

fprintf('\nState matrix of the aggregate plant.\n\n');
format short
fprintf('  %10.3f  %10.3f  %10.3f  %10.3f  %10.3f  %10.3f  %10.3f  %10.3f\n',a_mat_agg.');

fprintf('\nTable 5. Eigenvalues of the aggregate plant.\n\n');
format short
fprintf('    Eigenvalue             Frequency   Damping ratio\n');
fprintf('  %8.4f + j%7.4f    %8.4f    %8.4f\n', [real(d_agg), imag(d_agg), imag(d_agg)/2/pi, -cos(angle(d_agg))].');

% eof
