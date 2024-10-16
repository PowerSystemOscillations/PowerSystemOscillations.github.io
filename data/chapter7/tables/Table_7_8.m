% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.8

% 16mt3setgp16ss.mat: 16-machine system, PSSs on all generators except 1, 2, 14

clear all; close all; clc;
load('../mat/16mt3setgp16ss.mat');

%-------------------------------------%
% table 8

tol = 1e-7;

% sorting the eigenvalues and eigenvectors
[V,D] = eig(a_mat);

% participation vectors
W = pinv(V).';                  % left eigenvectors
Pv = V.*W;                      % participation vectors
Pvn = Pv./max(Pv);              % normalized participation vectors

st_idx = 1:1:size(a_mat,1);
spd_st = st_idx(mac_state(:,2) == 2);
Pvn_st = Pvn(spd_st,:);         % mode-in-state participation vector

dd = diag(D);
mask = (real(dd) > -1) & (imag(dd) > 0);
dd = dd(mask);
V = V(:,mask);
W = W(:,mask);
Pvn_st = Pvn_st(:,mask);

[~,d_ord] = sort(imag(dd),'ascend');
d = dd(d_ord);
V = V(:,d_ord);
W = W(:,d_ord);

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

% finding the generators with the largest participation/residues
Pvn_st = Pvn_st(:,d_ord);
[~,Gpmax] = max(abs(Pvn_st));

mask = -cos(angle(d)) < 0.06;
fprintf('\nTable 8. Underdamped modes after initial stabilizer installation.\n\n');
format short
disp(d(mask));

fprintf('\nTable 8 cont. Frequency and damping.\n\n');
format short
disp([imag(d(mask))/2/pi,round(-100*cos(angle(d(mask))),1),Gpmax(mask).']);

% eof