% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 6.3

% 16m1tdss.mat: 16-generator system with two tie-lines out of service
% 16m1tdhgss.mat: 16-gen. system with two tie-lines out of service and hydro governors
% 16m1tdtgss.mat: 16-gen. system with two tie-lines out of service and thermal governors

clear all; close all; clc;                    % reset workspace

td = load('../mat/16m1tdss.mat');
tdhy = load('../mat/16m1tdhgss.mat');
tdth = load('../mat/16m1tdtgss.mat');

%-------------------------------------%
% table 3

td_eig = eig(td.a_mat);
tdhy_eig = eig(tdhy.a_mat);
tdth_eig = eig(tdth.a_mat);

td_frq = imag(td_eig)/2/pi;
tdhy_frq = imag(tdhy_eig)/2/pi;
tdth_frq = imag(tdth_eig)/2/pi;

td_dmp = -cos(angle(td_eig));
tdhy_dmp = -cos(angle(tdhy_eig));
tdth_dmp = -cos(angle(tdth_eig));

tab63 = [td_frq(87), td_dmp(87), tdhy_frq(109), tdhy_dmp(109), tdth_frq(102), tdth_dmp(102);
         td_frq(76), td_dmp(76), tdhy_frq(92), tdhy_dmp(92), tdth_frq(92), tdth_dmp(92)];

fprintf('\nTable 3. Effect of turbine/governor systems on electromechanical oscillations\n\n');
fprintf('    No gov              Hydro gov           Thermal gov\n');
format short
disp(tab63);

% eof
