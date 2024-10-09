% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 4.2

% sbstsp.mat: state-space model for d2asb.m

clear all; close all; clc;
load('../mat/sbstsp.mat');

%-------------------------------------%
% table 2

format short
fprintf('\nC matrix\n\n')
disp(c_v(1,:).')

tab_str = ['\nTable 2. Entries of C_tg.\n\n'];
fprintf(tab_str);

state_str{1} = '\Delta\delta';
state_str{2} = '\Delta\omega';
state_str{3} = '\Delta E''_{q}';
state_str{4} = '\Delta\psi_{kd}';
state_str{5} = '\Delta E''_{d}';
state_str{6} = '\Delta\psi_{kq}';

for ii = 1:size(mac_state,1)
    if ii <= length(c_v(1,:))/4
        ng = 1;
    elseif ii > length(c_v(1,:))/4 && ii <= length(c_v(1,:))/2
        ng = 2;
    elseif ii > length(c_v(1,:))/2 && ii <= length(c_v(1,:))*3/4
        ng = 3;
    else
        ng = 4;
    end

    st_ii = state_str{mac_state(ii,2)};
    fprintf('%0.4f & %s & %0.4f \\\\\n',ng,st_ii,c_v(1,ii));
end

% eof
