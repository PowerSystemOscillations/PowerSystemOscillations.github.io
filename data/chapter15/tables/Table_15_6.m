% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 15.6

clear all; close all; clc;

%-------------------------------------%
% table 6

% grid-following case (reec)
load('../mat/d2asbegp_sweep_reec_p4pu_bus91.mat');

V = sweep_track(50).u;
W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pv = Pv./max(abs(Pv));                        % normalization
Pv_full = Pv(:,31);                           % exciter mode, all states
Pv_full = [Pv_full, sweep_track(50).st_vec];
mask = abs(Pv_full(:,1)) > 0.15;

Pv_mag = abs(Pv_full(mask,1));
Pv_ang = angle(Pv_full(mask,1))*180/pi;
Pv_ste = Pv_full(mask,2);
mask = ~ismember(Pv_ste,[2,4]);

fprintf('\nTable 16. Normalized participation vector for the area 1 exciter mode\n');
fprintf('          with the IBR capacity at 50%% of generator 1’s initial MVA base.\n\n');

fprintf('Grid-following case (reec)\n\n');
disp(sweep_track(50).l(31));
disp([Pv_mag(mask), Pv_ang(mask), Pv_ste(mask)]);

% grid-forming case (gfma)
load('../mat/d2asbegp_sweep_gfma_p4pu_bus91.mat')

V = sweep_track(50).u;
W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pv = Pv./max(abs(Pv));                        % normalization
Pv_full = Pv(:,30);                           % exciter mode, all states
Pv_full = [Pv_full, sweep_track(50).st_vec];
mask = abs(Pv_full(:,1)) > 0.15;

Pv_mag = abs(Pv_full(mask,1));
Pv_ang = angle(Pv_full(mask,1))*180/pi;
Pv_ste = Pv_full(mask,2);
mask = ~ismember(Pv_ste,[2,4]);

fprintf('Grid-forming case (gfma)\n\n');
disp(sweep_track(50).l(30));
disp([Pv_mag(mask), Pv_ang(mask), Pv_ste(mask)]);

% d2asbegp_sweep_base_p4pu.mat: eigenvalues of the base case
s = load('../mat/d2asbegp_sweep_base_p4pu.mat');

[V,D] = eig(s.a_mat);
W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pv = Pv./max(abs(Pv));                        % normalization
Pv_full = Pv(:,27);                           % exciter mode, all states
Pv_full = [Pv_full, s.st_vec];
mask = abs(Pv_full(:,1)) > 0.20;
% disp(D(27,27));
% disp([abs(Pv_full(mask,1)), angle(Pv_full(mask,1))*180/pi, Pv_full(mask,2)]);

% eof
