% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.21

% 16mt3setgss.mat: 16-machine system, 3 tie-lines, static exciters

clear all; close all; clc;
load('../mat/16mt3setgss.mat');

%-------------------------------------%
% fig 21

fig21_name = './csv/ch7_fig21.csv';

fig21 = figure;
ax21 = subplot(1,1,1,'parent',fig21);
hold(ax21,'on');

% sorting the eigenvalues and eigenvectors
[V,D] = eig(a_mat);
dd = diag(D);
[~,d_ord] = sort(imag(dd),'ascend');
dd = dd(d_ord);
V = V(:,d_ord);

W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pvn = Pv./max(Pv);                            % normalized participation vectors

g_idx = 1;                                    % generator 1 speed
st_idx = 1:1:size(a_mat,1);
spd_st = st_idx(mac_state(:,2) == 2);

Pvn_st = Pvn(spd_st(g_idx),:);                % mode-in-state participation vector
Pvn_st(abs(Pvn_st) < 0.1) = 0;

% finding the inter-area modes
em_idx = (imag(dd) > (0.01*2*pi) & imag(dd) < 2*2*pi & real(dd) > -2);
em_idx(129) = false;                          % frequency regulation mode

barh(ax21,real(Pvn_st(em_idx)));

yticks(ax21,1:15);
ylabel(ax21,'Mode number');
xlabel(ax21,'Real part of participation factor');

% exporting data file
H21 = {'k','pf'};
M21 = [1:1:length(Pvn_st(em_idx)); real(Pvn_st(em_idx))];

fid21 = fopen(fig21_name,'w');
fprintf(fid21,'%s,%s\n',H21{:});
fprintf(fid21,'%6e,%6e\n',M21);
fclose(fid21);

% eof
