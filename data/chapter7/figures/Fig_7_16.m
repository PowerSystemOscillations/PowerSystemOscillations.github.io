% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.16

% 16mt3setgss.mat: 16-machine system, static exciters, state-space

clear all; close all; clc;
load('../mat/16mt3setgss.mat');

%-------------------------------------%
% fig 16

fig16_name = './csv/ch7_fig16.csv';

fig16 = figure;
ax16 = subplot(1,1,1,'parent',fig16);
hold(ax16,'on');

% sorting the eigenvalues and eigenvectors
[V,D] = eig(a_mat);
dd = diag(D);
[~,d_ord] = sort(imag(dd),'ascend');
dd = dd(d_ord);
V = V(:,d_ord);

W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pvn = Pv./max(Pv);                            % normalized participation vectors

g_idx = 8;                                    % generator 8 speed
st_idx = 1:1:size(a_mat,1);
spd_st = st_idx(mac_state(:,2) == 2);

Pvn_st = Pvn(spd_st(g_idx),:);                % mode-in-state participation vector
Pvn_st(abs(Pvn_st) < 0.1) = 0;                % ignoring small participation factors

% finding the inter-area modes
em_idx = (imag(dd) > (0.01*2*pi) & imag(dd) < 2*2*pi & real(dd) > -2);
em_idx(129) = false;
barh(ax16,real(Pvn_st(em_idx)));

yticks(ax16,1:15);
ylabel(ax16,'Mode number');
xlabel(ax16,'Real part of participation factor');

% exporting data file
H16 = {'k','pf'};
M16 = [1:1:length(Pvn_st(em_idx)); real(Pvn_st(em_idx))];

fid16 = fopen(fig16_name,'w');
fprintf(fid16,'%s,%s\n',H16{:});
fprintf(fid16,'%6e,%6e\n',M16);
fclose(fid16);

% eof
