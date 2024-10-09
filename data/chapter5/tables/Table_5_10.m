% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 5.10

% 16m1tstsp.mat: 16-machine model with one tie-line in service
% 16m1tstsp.mat: 16-machine model with three tie-lines in service

clear all; close all; clc;                    % reset workspace
load('../mat/16m1tstsp.mat');                 % state-space model

%-------------------------------------%
% table 10

tol = 1e-7;

[~,D] = eig(a_mat);
tmp = diag(D);
d1t = sort(tmp(abs(imag(tmp)) > tol),'ascend');
mask = abs(imag(d1t)) > 2.3 & abs(imag(d1t)) < 5;
d1t = d1t(mask);

load('../mat/16m3tstsp.mat');                 % state-space model

[~,D] = eig(a_mat);
d3t = sort(diag(D),'ascend');
mask = abs(imag(d3t)) > 2.4 & abs(imag(d3t)) < 5;
d3t = d3t(mask);

fprintf('\nTable 10. Low frequency modes.\n\n');
fprintf('   one tie line       three tie lines\n');
format short;
disp([d1t,d3t]);

fprintf('Table 10 cont. Low frequency mode frequencies.\n\n');
fprintf('one tie (Hz)  three ties (Hz)\n');
format short;
disp([imag(d1t(2:2:end))/2/pi,imag(d3t(2:2:end))/2/pi]);

% eof
