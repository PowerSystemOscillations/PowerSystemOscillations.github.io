% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.22

% 16mt3setgss.mat: 16-machine system, 3 tie-lines, static exciters

clear all; close all; clc;
load('../mat/16mt3setgss.mat');

%-------------------------------------%
% fig 22

fig22_name = './csv/ch7_fig22.csv';

fig22 = figure;
ax22 = subplot(1,1,1,'parent',fig22);
hold(ax22,'on');

% sorting the eigenvalues and eigenvectors
[V,D] = eig(a_mat);
dd = diag(D);
[~,d_ord] = sort(imag(dd),'ascend');
dd = dd(d_ord);
V = V(:,d_ord);

W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pvn = Pv./max(Pv);                            % normalized participation vectors

g_idx = 2;                                    % generator 2 speed
st_idx = 1:1:size(a_mat,1);
spd_st = st_idx(mac_state(:,2) == 2);

Pvn_st = Pvn(spd_st(g_idx),:);                % mode-in-state participation vector
Pvn_st(abs(Pvn_st) < 0.1) = 0;

% finding the inter-area modes
em_idx = (imag(dd) > (0.01*2*pi) & imag(dd) < 2*2*pi & real(dd) > -2);
em_idx(129) = false;  % frequency regulation mode

barh(ax22,real(Pvn_st(em_idx)));

yticks(ax22,1:15);
ylabel(ax22,'Mode number');
xlabel(ax22,'Real part of participation factor');

% exporting data file
H22 = {'k','pf'};
M22 = [1:1:length(Pvn_st(em_idx)); real(Pvn_st(em_idx))];

fid22 = fopen(fig22_name,'w');
fprintf(fid22,'%s,%s\n',H22{:});
fprintf(fid22,'%6e,%6e\n',M22);
fclose(fid22);

% eof
