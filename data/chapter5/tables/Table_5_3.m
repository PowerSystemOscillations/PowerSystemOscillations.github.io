% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 5.3

% 16memstsp.mat: state-space model of the 16-generator system

clear all; close all; clc;
load('../mat/16memstsp.mat');

%-------------------------------------%
% table 3

[~,D] = eig(a_mat);
d = sort(diag(D),'ascend');
tol = 1e-7;

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

fprintf('\nTable 3. Resonant frequencies of the 16-generator system.\n\n');
format short
mask = (imag(d) >= 0);
d_sort = sort(imag(d(mask).')/2/pi);
disp([d_sort(2:9); d_sort(10:end)]);

% coherency matrix

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

fprintf('\nCoherency matrix part 1.\n\n');
format short
disp(G_full(:,1:8));

fprintf('\nCoherency matrix part 2.\n\n');
format short
disp(G_full(:,9:end));

% eof
