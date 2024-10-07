% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 4.4

% sbgstsp.mat: state-space model for two-area system with turbine/governors

clear all; close all; clc;
load('../mat/sbgstsp.mat');
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

fprintf('\nTable 4. Eigenvalues with governors added.\n\n');
format short
disp(d)

% eof
