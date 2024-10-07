% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 3.10

% emstsp.mat: state-space model for d2aem.m

clear all; close all; clc;
load('../mat/emstsp.mat');
tol = 1e-7;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

Vn = zeros(size(V));
for ii = 1:size(V,2)
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);              % post-normalization
end

% W = pinv(Vn).';                             % left eigenvectors
Pv = V.*pinv(V).';                            % participation vectors

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(Pv,2)
    for ii = 1:size(Pv,1)
        if abs(real(Pv(ii,jj))) < tol
            Pv(ii,jj) = 0 + 1j*imag(Pv(ii,jj));
        elseif abs(imag(Pv(ii,jj))) < tol
            Pv(ii,jj) = real(Pv(ii,jj));
        end
    end
end

fprintf('\nTable 10. Participation vector for the inter-area mode\n\n');
fprintf('lambda = %0.4f+1j%0.4f\n\n',real(d(4)),imag(d(4)));
format short
disp(Pv(:,4))

% eof
