% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.3

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% table 3

% sorting the eigenvalues and eigenvectors
[V,D] = eig(a_mat);
dd = diag(D);
[~,d_ord] = sort(dd,'ascend');
dd = dd(d_ord);
V = V(:,d_ord);

W = pinv(V).';                                % left eigenvectors
Ri = zeros(size(a_mat,1),1);                  % residue vector

for ii = 1:length(Ri)
    Ri(ii) = c_spd*V(:,ii)*W(:,ii).'*b_vr;
end

fprintf('\nTable 3. Residue angles.\n\n');
format short
disp(dd)
disp([angle(Ri)*180/pi]);

% eof
