% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 3.7

% emstsp.mat: state-space model for d2aem.m

clear all; close all; clc;
load('../mat/emstsp.mat');

%-------------------------------------%
% table 7

tol = 1e-7;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

Vn = zeros(size(V));
for ii = 1:size(V,2)
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);              % post-normalization
end

W = pinv(Vn).';                               % left eigenvectors

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(W,2)
    for ii = 1:size(W,1)
        if abs(real(W(ii,jj))) < tol
            W(ii,jj) = 0 + 1j*imag(W(ii,jj));
        elseif abs(imag(W(ii,jj))) < tol
            W(ii,jj) = real(W(ii,jj));
        end
    end
end

fprintf('Table 7. Left eigenvectors for the local modes\n\n');
fprintf('lambda = %0.4f+j%0.4f\nlambda = %0.4f+j%0.4f\n\n', ...
        real(d(6)),imag(d(6)),real(d(8)),imag(d(8)));
format short
disp([W(:,6).'; W(:,8).'])

% eof
