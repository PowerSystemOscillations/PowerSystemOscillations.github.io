% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.2

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% table 2

% sorting the eigenvalues and eigenvectors
[V,D] = eig(a_mat);
dd = diag(D);
[~,d_ord] = sort(dd,'ascend');
dd = dd(d_ord);
V = V(:,d_ord);

W = pinv(V).';                                % left eigenvectors
Pv = V.*W;                                    % participation vectors
Pvn = Pv./max(abs(Pv));                       % normalization

% finding the inter-area modes
em_idx = (imag(dd) > (0.01*2*pi) & imag(dd) < 2*2*pi & real(dd) > -2);
em_idx(end) = false;  % frequency regulation mode

fprintf('\nTable 2. Participation factors for the underdamped oscillatory mode.\n\n');
format short
%disp(Pvn(:,em_idx));
disp([abs(Pvn(:,em_idx)),round(angle(Pvn(:,em_idx))*180/pi,1)]);

% eof
