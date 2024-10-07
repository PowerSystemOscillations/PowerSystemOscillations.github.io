% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 3.18

% sbegstsp.mat: state-space model for d2asbeg.m

clear all; close all; clc;
load('../mat/sbegstsp.mat');
tol = 1e-9;

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

Pv = Pv./max(abs(Pv));                        % normalization
fprintf('\nTable 18. Participation vector for the unstable inter-area mode\n\n');
fprintf('lambda = %0.4f+1j%0.4f\n\n',real(d(16)),imag(d(16)));
format short
fprintf('%0.4f \\angle \\SI{%0.1f}{\\degree}\n',[abs(Pv(:,16)),angle(Pv(:,16))*180/pi].');

% eof
