% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 5.1

% data4memstsp.mat: state-space model of the 4-generator plant

clear all; close all; clc;
load('../mat/data4memstsp.mat');

%-------------------------------------%
% table 1

tol = 1e-7;

wb = 2*pi*60;
T = diag([1 wb 1 wb 1 wb 1 wb]);
A_T = T*a_mat*inv(T);

[~,D] = eig(A_T);
d = sort(diag(D),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

fprintf('\nTable 1. Eigenvalues of the 4-generator plant.\n\n');
format short
disp(d);

% eof
