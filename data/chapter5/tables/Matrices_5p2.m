% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% matrices in section 5.2, 4-generator plant

% data4memstsp.mat: state-space model of the 4-generator plant

clear all; close all; clc;
load('../mat/data4memstsp.mat');
tol = 1e-7;

wb = 2*pi*60;
T = diag([1 wb 1 wb 1 wb 1 wb]);

P = eye(8);
P(3:4,1:2) = -eye(2);
P(5:6,1:2) = -eye(2);
P(7:8,1:2) = -eye(2);

A_T = T*a_mat*inv(T);
A_P = P*A_T*inv(P);
A_P(abs(A_P) < tol) = 0;

fprintf('\nState matrix of the 4-generator plant.\n\n');
format short
disp(A_T);

fprintf('\nTransformation matrix.\n\n');
format short
disp(P);

fprintf('\nTransformed state matrix of the 4-generator plant.\n\n');
format short
disp(A_P);

fprintf('\nEigenvalues of the first 2-by-2 block.\n\n');
format short
disp(eig(A_P(1:2,1:2)));

fprintf('\nEigenvalues of the other 2-by-2 blocks.\n\n');
format short
disp(eig(A_P(3:4,3:4)));

%% matrices in section 5.2, aggregate model

% data4magemstsp.mat: state-space model of the aggregate plant

clear all; close all;
load('../mat/data4magemstsp.mat');
tol = 1e-7;

wb = 2*pi*60;
T = diag([1 wb]);
A_T = T*a_mat*inv(T);

[~,D] = eig(A_T);
d = sort(diag(D),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

fprintf('\nState matrix of the aggregate plant.\n\n');
format short
disp(A_T);

fprintf('\nEigenvalues of the aggregate plant model.\n\n');
format short
disp(d);

% eof
