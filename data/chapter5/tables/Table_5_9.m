% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 5.9

clear all; close all; clc;

%-------------------------------------%
% table 9

line = {...
   '52' '42'  '0.0040'  '0.0600'  '2.2500'  '1,3';
   '42' '41'  '0.0040'  '0.0600'  '2.2500'  '1,2';
   '48' '40'  '0.0020'  '0.0220'  '1.2800'  '2,5';
   '49' '52'  '0.0076'  '0.1141'  '1.1600'  '3,5';
   '50' '51'  '0.0009'  '0.0221'  '1.6200'  '3,5';
   ' 1' ' 2'  '0.0035'  '0.0411'  '0.6987'  '4,5';
   ' 1' '27'  '0.0320'  '0.3200'  '0.4100'  '4,5';
   ' 8' ' 9'  '0.0023'  '0.0363'  '0.3804'  '4,5'};

fprintf('\nTable 9. Tie line data.\n\n');
fprintf('     from       to          R             X             B         groups\n');
format short;
disp(line);

% eof
