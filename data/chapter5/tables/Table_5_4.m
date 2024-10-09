% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 5.4

% 16memstsp.mat: state-space model of the 16-generator system

clear all; close all; clc;                    % reset workspace
load('../mat/16memstsp.mat');                 % state-space model

%-------------------------------------%
% table 4

ang_idx = 1:2:size(a_mat,1);                  % rotor angle state index
ref_idx = [15,14,16,5,13];                    % reference generators
coh_eigs_idx = 1:1:10;                        % electromechanical modes

% u - eigenvector matrix, l - eigenvalues
W_ref = u(ang_idx(ref_idx),coh_eigs_idx);
W_gen = u(ang_idx,coh_eigs_idx);
W_bus = c_ang*u(:,coh_eigs_idx);

n_ref = size(W_ref,1);
n_gen = size(W_gen,1);
n_bus = size(W_bus,1);

% coherency matrix with all gens included
G_full = zeros(n_gen,n_gen);
for ii = 1:n_gen
    for jj = 1:n_gen
        G_full(ii,jj) = abs(W_gen(ii,:)*W_gen(jj,:).') ...
                       /(norm(W_gen(ii,:),2)*norm(W_gen(jj,:),2));
    end
end

% coherency matrix with reference gens only
G_gen = zeros(n_ref,n_gen);
for ii = 1:n_ref
    for jj = 1:n_gen
        G_gen(ii,jj) = abs(W_ref(ii,:)*W_gen(jj,:).') ...
                       /(norm(W_ref(ii,:),2)*norm(W_gen(jj,:),2));
    end
end

% coherency matrix for bus voltage angles
G_bus = zeros(n_ref,n_bus);
for ii = 1:n_ref
    for jj = 1:n_bus
        G_bus(ii,jj) = abs(W_ref(ii,:)*W_bus(jj,:).') ...
                       /(norm(W_ref(ii,:),2)*norm(W_bus(jj,:),2));
    end
end

line = [...
         1   2;
         1  27;
         8   9;
        40  48;
        41  42;
        42  52;
        49  52;
        50  51];

gmax = 0;
for ii = 1:length(ref_idx)
    % generator coherency groups
    [~,midx] = max(G_gen,[],1);
    tmp = 1:1:n_gen;
    group(ii).gens = tmp(midx == ii);

    if (length(group(ii).gens) > gmax)
        gmax = length(group(ii).gens);
    end

    % bus coherency groups
    [~,midx] = max(G_bus,[],1);
    tmp = 1:1:n_bus;
    group(ii).buses = tmp(midx == ii);

    group(ii).frombus = [];
    group(ii).tobus = [];
    mask = false(size(line,1),1);

    for jj = 1:length(group(ii).buses)
        from_mask = (group(ii).buses(jj) == line(:,1));
        to_mask = (group(ii).buses(jj) == line(:,2));
        mask = (mask | from_mask | to_mask);
    end

    group(ii).frombus = [group(ii).frombus, line(mask,1).'];
    group(ii).tobus = [group(ii).tobus, line(mask,2).'];
end

fprintf('\nTable 4. Group 1: Reference generator 15.\n\n');
format short
fprintf('Generators: '); fprintf('%2.0f  ',group(1).gens.');
fprintf('\nBuses:      '); fprintf('%2.0f  ',group(1).buses.');
fprintf('\nFrom bus:   '); fprintf('%2.0f  ',group(1).frombus.');
fprintf('\nTo bus:     '); fprintf('%2.0f  ',group(1).tobus.');
fprintf('\n\n');
% eof
