% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.7

clear all; close all; clc;

%-------------------------------------%
% table 7

t_str = {' 3', '10', '10', '0.04', '0.02', '0.10', '0.01';
         ' 4', ' 5', '10', '0.08', '0.02', '0.08', '0.02';
         ' 5', ' 5', '10', '0.05', '0.01', '0.08', '0.02';
         ' 6', ' 8', '10', '0.05', '0.01', '0.08', '0.02';
         ' 8', ' 3', '10', '0.08', '0.01', '0.08', '0.02';
         ' 9', '10', '10', '0.05', '0.01', '0.05', '0.02';
         '10', '10', '10', '0.08', '0.01', '0.08', '0.02';
         '11', ' 3', '10', '0.08', '0.03', '0.05', '0.01';
         '12', '10', '10', '0.08', '0.01', '0.08', '0.01';
         '13', '20', '10', '0.04', '0.01', '0.05', '0.01';
         '15', '20', '10', '0.04', '0.01', '0.05', '0.01';
         '16', '20', '10', '0.03', '0.02', '0.05', '0.10'};

fprintf('\nTable 7.  Power system stabilizer parameters.\n');
fprintf('\n     Gen.      Gain      Tw        T1          T2          T3          T4\n');
format short
disp(t_str);

% eof
