% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.1

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% table 1

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

fprintf('\nTable 1. Eigenvalues with a static exciter.\n\n');
format short
disp(d);

fprintf('\nTable 1 cont. Frequency and damping.\n\n');
format short
disp([imag(d)/2/pi,-100*cos(angle(d))]);

% eof
