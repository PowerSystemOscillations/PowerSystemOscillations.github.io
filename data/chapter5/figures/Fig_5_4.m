% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 5.4

% 16memstsp.mat: 16-machine system with classical generator models, data16em.m

clear all; close all; clc;                    % reset workspace
load('../mat/16memstsp.mat');                 % state-space model

fig4_name = './csv/ch5_fig4.csv';

ang_idx = 1:2:size(a_mat,1);                  % rotor angle state index
eigs_idx = 2:2:10;                            % electromechanical modes

fig4 = figure;
for ii = 1:5
    ax4{ii} = subplot(5,1,ii,'parent',fig4);
    hold(ax4{ii},'on');
end

% normalizing the rotor angle eigenvectors
V_ang = u(ang_idx,:);
[vmax,vidx] = max(abs(real(V_ang)),[],1,'linear');
V_ang = V_ang*diag(1./(vmax.*sign(V_ang(vidx))));

for ii = 1:numel(ax4)
    bar(ax4{ii},real(V_ang(:,eigs_idx(ii))));
    axis(ax4{ii},[0,17,-1,1]);
    ylabel(ax4{ii},['eig',num2str(ii)]);
end

xlabel(ax4{end},'Generator number');

H4 = {'k','v1','v2','v3','v4','v5'};
M4 = [1:1:size(V_ang,1); real(V_ang(:,eigs_idx)).'];

% gen | v1 | v2 | etc.
fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s,%s,%s,%s\n',H4{:});
fprintf(fid4,'%6e,%6e,%6e,%6e,%6e,%6e\n',M4);
fclose(fid4);

% eof
