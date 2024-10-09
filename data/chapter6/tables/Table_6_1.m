% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 6.1

% hydrotss.mat: hydro governor root locus

clear all; close all; clc;                    % reset workspace
load('../mat/hydrotss.mat');                  % state-space model

%-------------------------------------%
% table 1

cstr = '\nTable 1. Eigenvalues of the turbine/governor system ';
cstr = [cstr, 'with a transient droop of Rt = 0.4.\n\n'];
fprintf(cstr);
format short
disp([real(rlhg4g(:,5)),imag(rlhg4g(:,5))]);

% eof
