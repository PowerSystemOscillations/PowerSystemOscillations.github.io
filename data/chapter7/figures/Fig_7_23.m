% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.23

% 16mt3setgp16ss.mat: 16-machine system, PSSs on all generators except 1, 2

clear all; close all; clc;
load('../mat/16mt3setgp16ss.mat');

%-------------------------------------%
% fig 23

fig23_name = './csv/ch7_fig22.csv';

fig23 = figure;
ax23 = subplot(1,1,1,'parent',fig23);
hold(ax23,'on');

% sorting the eigenvalues and eigenvectors
[V,D] = eig(a_mat);
dd = diag(D);
[~,d_ord] = sort(imag(dd),'ascend');
dd = dd(d_ord);
V = V(:,d_ord);

spd_mask = (mac_state(:,2) == 2);

W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pv = Pv(spd_mask,:);                          % generator speeds only
Pvn = Pv./max(Pv);                            % normalization

% finding the underdamped mode (not undamped!)
m_idx = (imag(dd) > 8.9 & imag(dd) < 9.0 & real(dd) > -2);

Pvn_m = real(Pvn(:,m_idx));                   % state-in-mode participation vector
Pvn_m(abs(Pvn_m) < 0.1) = 0;

barh(ax23,real(Pvn_m));

yticks(ax23,1:16);
ylabel(ax23,'Generator number');
xlabel(ax23,'Real part of participation factor');

% exporting data file
H23 = {'k','pf'};
M23 = [1:1:length(Pvn_m); real(Pvn_m).'];

fid23 = fopen(fig23_name,'w');
fprintf(fid23,'%s,%s\n',H23{:});
fprintf(fid23,'%6e,%6e\n',M23);
fclose(fid23);

% eof
