% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 3.1

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
    Vn(:,ii) = V(:,ii)./V(I,ii);            % post-normalization
end

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(Vn,2)
    for ii = 1:size(Vn,1)
        if abs(real(Vn(ii,jj))) < tol
            Vn(ii,jj) = 0 + 1j*imag(Vn(ii,jj));
        elseif abs(imag(Vn(ii,jj))) < tol
            Vn(ii,jj) = real(Vn(ii,jj));
        end
    end
end

fprintf('Table 4. Right eigenvectors for the local modes\n\n');
fprintf('lambda = %0.4f+j%0.4f, lambda = %0.4f+j%0.4f\n\n', ...
        real(d(6)),imag(d(6)),real(d(8)),imag(d(8)));
format short
disp([Vn(:,6),Vn(:,8)])
for ii = 1:length(Vn(:,8))
    if abs(real(Vn(ii,8))) > 0
        fprintf('%0.4f\n',real(Vn(ii,8)));
    else
        if imag(Vn(ii,8)) > 0
            fprintf('j%0.4f\n',imag(Vn(ii,8)));
        else
            fprintf('-j%0.4f\n',abs(imag(Vn(ii,8))));
        end
    end
end
fprintf('\n');

% eof