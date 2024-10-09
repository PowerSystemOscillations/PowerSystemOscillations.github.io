% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 5.6

% 16m3tstsp: 16-machine system with a three ties between areas 4 and 5

clear all; close all; clc;                    % reset workspace
load('../mat/16m3tstsp.mat');                 % state-space model

%-------------------------------------%
% figs

fig6_name = './csv/ch5_fig6.csv';

fig6 = figure;
for ii = 1:5
    ax6{ii} = subplot(5,1,ii,'parent',fig6);
    hold(ax6{ii},'on');
end

[V,D] = eig(a_mat);
ang_mask = (mac_state(:,2) == 1);             % rotor angle state index
eigs_idx = [105,73,71,69,67];                 % eigenvalues of interest
V_ang = V(ang_mask,:);

% normalizing the rotor angle eigenvectors
[vmax,vidx] = max(abs(real(V_ang)),[],1,'linear');
V_ang = V_ang*diag(1./(vmax.*sign(V_ang(vidx))));

for ii = 1:numel(ax6)
    bar(ax6{ii},real(V_ang(:,eigs_idx(ii))));
    axis(ax6{ii},[0,17,-1,1]);
    ylabel(ax6{ii},['eig',num2str(ii)]);
end

xlabel(ax6{end},'Generator number');

H6 = {'k','v1','v2','v3','v4','v5'};
M6 = [1:1:size(V_ang,1); real(V_ang(:,eigs_idx)).'];

% gen | v1 | v2 | etc.
fid6 = fopen(fig6_name,'w');
fprintf(fid6,'%s,%s,%s,%s,%s,%s\n',H6{:});
fprintf(fid6,'%6e,%6e,%6e,%6e,%6e,%6e\n',M6);
fclose(fid6);

% eof
