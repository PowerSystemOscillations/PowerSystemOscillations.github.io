% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.5

% d16mgdcetgibss.mat: 16-machine system, SMIB model for G16, dc exciter

clear all; close all; clc;
load('../mat/d16mgdcetgibss.mat');

%-------------------------------------%
% table 5

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

fprintf('\nTable 5. Eigenvalues with a dc exciter.\n\n');
format short
disp(d);

fprintf('\nTable 5 cont. Frequency and damping.\n\n');
format short
disp([imag(d)/2/pi,-cos(angle(d))]);

% eof
