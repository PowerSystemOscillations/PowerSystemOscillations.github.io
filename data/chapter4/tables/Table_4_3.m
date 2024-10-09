% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 4.3

% sbstsp.mat: state-space model for d2asb.m

clear all; close all; clc;
load('../mat/sbstsp.mat');

%-------------------------------------%
% table 3

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

mask = (real(d) < -19.99 & real(d) > -20.01);
d(mask) = [];
p = d;

k = 1e6;
An = a_mat - k*b_efd*c_v(1,:);

[~,D] = eig(An);
d = sort(diag(D),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

mask = (real(d) < -19.99 & real(d) > -20.01);
d(mask) = [];
dn = d;

Ap = a_mat + k*b_efd*c_v(1,:);

[~,D] = eig(Ap);
d = sort(diag(D),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

mask = (real(d) < -19.99 & real(d) > -20.01);
d(mask) = [];
dp = d;

fprintf('\nTable 3. Poles and zeros of the modified system with feedback.\n\n');
format short
disp([p(1:end-1),dn(1:end-1),dp(1:end-1)])
format longg
disp([p(end),dn(end),dp(end)])

% eof
