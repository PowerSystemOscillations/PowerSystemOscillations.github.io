% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 7.6

% 16mt3setgss.mat: 16-machine system, static exciters, state-space

clear all; close all; clc;
load('../mat/16mt3setgss.mat');

%-------------------------------------%
% table 6

tol = 1e-7;

% sorting the eigenvalues and eigenvectors
[V,D] = eig(a_mat);

% participation vectors
W = pinv(V).';                  % left eigenvectors
Pv = V.*W;                      % participation vectors
Pvn = Pv./max(abs(Pv));         % normalized participation vectors

st_idx = 1:1:size(a_mat,1);
spd_st = st_idx(mac_state(:,2) == 2);
Pvn_st = Pvn(spd_st,:);         % mode-in-state participation vector

% transfer function residues
Ri = zeros(length(spd_st),size(a_mat,1));
for ii = 1:size(Ri,1)
    for jj = 1:size(Ri,2)
        Ri(ii,jj) = c_spd(ii,:)*V(:,jj)*W(:,jj).'*b_vr(:,ii);
    end
end

dd = diag(D);
mask = (real(dd) > -1) & (imag(dd) > 0);
dd = dd(mask);
V = V(:,mask);
W = W(:,mask);
Pvn_st = Pvn_st(:,mask);
Ri = Ri(:,mask);

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
Ri = Ri(:,d_ord);
[~,Gpmax] = max(abs(Pvn_st));
[~,Grmax] = max(abs(Ri));

fprintf('\nTable 6. Underdamped modes of the 16-generator system.\n\n');
format short
disp(d(2:end));

fprintf('\nTable 6 cont. Frequency and damping.\n\n');
format short
disp([imag(d(2:end))/2/pi,round(-100*cos(angle(d(2:end))),1),Gpmax(2:end).',Grmax(2:end).']);

% eof
