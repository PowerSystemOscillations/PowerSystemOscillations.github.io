% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 6.2

clear all; close all; clc;

%-------------------------------------%
% table 2

tstr = {'K_g', '25';
        'T_sm','0.1 s';
        'T_si','0.1 s';
        'K_r', '2.5';
        'T_hp','0.5 s';
        'T_rh','3 s';
        'T_ip','0.1 s';
        'T_lp','0.2 s';
        'F_hp','0.25';
        'F_lp','0.75'};

fprintf('\nTable 2. Typical parameters for the thermal turbine/governor model\n\n');
format short
disp(tstr);

% eof
