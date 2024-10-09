% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 5.5

% 16m1tstsp.mat: 16-machine system with a single tie between areas 4 and 5

clear all; close all; clc;                    % reset workspace
load('../mat/16m1tstsp.mat');                 % state-space model

%-------------------------------------%
% figs

fig5_name = './csv/ch5_fig5.csv';

fig5 = figure;
for ii = 1:5
    ax5{ii} = subplot(5,1,ii,'parent',fig5);
    hold(ax5{ii},'on');
end

[V,~] = eig(a_mat);
ang_mask = (mac_state(:,2) == 1);             % rotor angle state index
eigs_idx = [105,73,71,69,67];                 % eigenvalues of interest
V_ang = V(ang_mask,:);

% normalizing the rotor angle eigenvectors
[vmax,vidx] = max(abs(real(V_ang)),[],1,'linear');
V_ang = V_ang*diag(1./(vmax.*sign(V_ang(vidx))));

for ii = 1:length(eigs_idx)
    bar(ax5{ii},real(V_ang(:,eigs_idx(ii))));
    axis(ax5{ii},[0,17,-1,1]);
    ylabel(ax5{ii},['eig',num2str(ii)]);
end

xlabel(ax5{end},'Generator number');

H5 = {'k','v1','v2','v3','v4','v5'};
M5 = [1:1:size(V_ang,1); real(V_ang(:,eigs_idx)).'];

% gen | v1 | v2 | etc.
fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s,%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e,%6e,%6e,%6e\n',M5);
fclose(fid5);

% eof
