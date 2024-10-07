% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 4.1

% sbstsp.mat: state-space model for d2asb.m

clear all; close all; clc;
load('../mat/sbstsp.mat');
tol = 1e-7;

[~,D] = eig(a_mat);
d = sort(diag(D),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

tab_str = ['\nTable 1. Eigenvalues of the of two area system with ', ...
           'subtransient generator models and no controls.\n\n'];

fprintf(tab_str);
format short
disp(d)

% eof
