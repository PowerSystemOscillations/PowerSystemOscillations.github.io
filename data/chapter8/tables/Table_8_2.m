% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 8.2

% datalaag_smib_tor.mat: single-machine infinite bus model with torsional dynamics

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

%-------------------------------------%
% table 2

eigvec = eig(smib_tor.a_mat);
eigvec = eigvec(7:-2:1)

fprintf('\nTable 2. Turbine/generator shaft torsional frequencies.\n\n');
format shortg
disp(imag(eigvec)/2/pi)

% eof
