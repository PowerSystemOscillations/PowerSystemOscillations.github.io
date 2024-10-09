% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 5.2

% 16memstsp.mat: 16-machine system with classical generator models, data16em.m

clear all; close all; clc;                    % reset workspace
load('../mat/16memstsp.mat');                 % state-space model

%-------------------------------------%
% fig 2

fig2_name = './csv/ch5_fig2.csv';

fig2 = figure;
ax21 = subplot(1,1,1,'parent',fig2);
hold(ax21,'on');

ang_idx = 1:2:size(a_mat,1);                  % rotor angle state index
ref_idx = [15,14,16,5,13];                    % reference generators
coh_eigs_idx = 2:2:10;                        % electromechanical modes

% u - eigenvector matrix, l - eigenvalues
W_ref = u(ang_idx(ref_idx),coh_eigs_idx);
W_gen = u(ang_idx,coh_eigs_idx);
W_bus = c_ang*u(:,coh_eigs_idx);
% W_bus = [u(ang_idx(ref_idx),coh_eigs_idx); c_ang(:,ang_idx)*u(ang_idx,coh_eigs_idx)];

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

    % plotting generator groups
    plot(ax21,ii*ones(size(group(ii).gens)),group(ii).gens,'b*');
end

set(ax21,'ydir','reverse');
xlabel(ax21,'Group number');
ylabel(ax21,'Generator number');

H2 = {'k1','g1','k2','g2','k3','g3','k4','g4','k5','g5'};
M2 = -1*ones(2*numel(group),gmax);
for ii = 1:numel(group)
    M2(2*ii-1,:) = ii;
    M2(2*ii,1:length(group(ii).gens)) = group(ii).gens;
end

% group gen | group gen | etc.
fid2 = fopen(fig2_name,'w');
fprintf(fid2,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H2{:});
fprintf(fid2,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M2);
fclose(fid2);

% eof
