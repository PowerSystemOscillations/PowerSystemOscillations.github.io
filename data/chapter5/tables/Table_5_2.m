% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 5.2

% data4memstsp.mat: state-space model of the 4-generator plant

clear all; close all; clc;
load('../mat/data4memstsp.mat');

%-------------------------------------%
% table 2

tol = 1e-7;

wb = 2*pi*60;
T = diag([1 wb 1 wb 1 wb 1 wb]);
A_T = T*a_mat*inv(T);

[V,D] = eig(A_T);
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

fprintf('\nTable 2: Right eigenvector of the plant mode.\n\n');
fprintf('lambda = 0 + j%0.4f\n\n',imag(d(2)));
format short
disp(Vn(:,2));

% eof