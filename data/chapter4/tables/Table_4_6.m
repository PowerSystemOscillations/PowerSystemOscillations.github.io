% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 4.6

% smibc.mat: smib model for generator 1, state-space

clear all; close all; clc;                    % reset workspace
load('../mat/smibc.mat');                     % state-space model

%-------------------------------------%
% table 6

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

fprintf('\nTable 6. Eigenvalues of the of single-machine infinite bus system.\n\n');
format short
disp(d(1:end-1))
format longg
disp(d(end))

% eof
