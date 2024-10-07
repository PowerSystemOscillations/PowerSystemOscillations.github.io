% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 3.13

% sbstsp.mat: state-space model for d2asb.m

clear all; close all; clc;
load('../mat/sbstsp.mat');
tol = 1e-7;

[~,D] = eig(a_mat);
d = sort(diag(D),'ascend');

a_matm = a_mat;
spd_idx = find(mac_state(:,2) == 2);
for ii = 1:length(spd_idx)
    a_matm(spd_idx(ii),spd_idx(ii)) = a_matm(spd_idx(ii),spd_idx(ii)) - 0.5;
end

[~,Dm] = eig(a_matm);
dm = sort(diag(Dm),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for ii = 1:length(dm)
    if abs(real(dm(ii))) < tol
        dm(ii) = 0 + 1j*imag(dm(ii));
    elseif abs(imag(dm(ii))) < tol
        dm(ii) = real(dm(ii));
    end
end

fprintf('\nTable 13. Damping ratio and frequency of the electromechanical oscillations f\n\n');
fprintf('Damping ratio, Frequency (Hz)\n\n');
format short
mask = (real(d) < 0 & imag(d) > 0);
disp([-cos(angle(d(mask))),imag(d(mask))/2/pi])
fprintf('Eigenvalue\n\n');
disp(d(mask));

% eof
