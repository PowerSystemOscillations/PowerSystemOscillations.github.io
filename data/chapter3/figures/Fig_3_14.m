% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.14

% sbegstsp.mat: state-space model for d2asbeg.m

clear all; close all; clc;                    % reset workspace
load('../mat/sbegstsp.mat');                  % state-space model

%-------------------------------------%
% fig 14

fig14_name = './csv/ch3_fig14.csv';           % data file

% inter-area mode corresponds to the 25th and 26th eigenvalues
[V,D] = eig(a_mat);

W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pv = Pv./max(abs(Pv));                        % normalization
Pv_full = Pv(:,25);                           % inter-area mode, all states
Pv_thresh = Pv_full(abs(Pv_full) > 0.05);     % top 12

fig14 = figure;
ax141 = subplot(1,1,1,'parent',fig14);
cp = compass(ax141,Pv_thresh);

legend(ax141,['g1,ang'],['g1,spd'],['g1,Eq'''], ...
             ['g2,ang'],['g2,spd'],['g2,Eq'''], ...
             ['g3,ang'],['g3,spd'],['g3,psid'], ...
             ['g4,ang'],['g4,spd'],['g4,psid'], ...
             'location','southEastOutside');

cmap = lines(6);
cmap_state = [1,2,3,1,2,3,1,2,4,1,2,4];
for ii = 1:numel(cp)
    cp(ii).Color = cmap(cmap_state(ii),:);
    if (ii > 3 && ii < 7)
        cp(ii).LineStyle = '--';
    elseif (ii > 6 && ii < 10)
        cp(ii).LineStyle = ':';
        cp(ii).LineWidth = 1.25;
    elseif (ii > 9)
        cp(ii).LineStyle = '-.';
    end
end

H14 = {'k','mag','ang','re','im'};
M14 = [1:length(Pv_thresh); abs(Pv_thresh).'; (180/pi)*angle(Pv_thresh).';
       real(Pv_thresh).'; real(Pv_thresh).'];

fid14 = fopen(fig14_name,'w');
fprintf(fid14,'%s,%s,%s,%s,%s\n',H14{:});
fprintf(fid14,'%6e,%6e,%6e,%6e,%6e\n',M14);
fclose(fid14);

% eof
