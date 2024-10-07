% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 4.5

% sbgstsp.mat: state-space model for two-area system with turbine/governors

clear all; close all; clc;                    % reset workspace
load('../mat/sbgstsp.mat');                   % state-space model
tol = 1e-7;

[V,D] = eig(a_mat);
[dd,sidx] = sort(diag(D),'ascend');
V = V(:,sidx);

W = pinv(V).';                                % left eigenvectors
r(1) = c_v(1,:)*V(:,1)*W(:,1).'*b_efd;        % residue for d(1);
r(2) = c_v(1,:)*V(:,2)*W(:,2).'*b_efd;        % residue for d(2);

mask = (abs(imag(r)) < tol);
r(mask) = real(r);

fprintf('\nTable 5. Residues for the two small real positive eigenvalues.\n\n');
format short
disp([dd(1:2), r.']);

% eof
