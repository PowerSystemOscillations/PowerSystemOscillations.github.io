% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.5

% sbgstsp.mat: detailed generator model with turbine governors, state-space

clear all; close all; clc;                    % reset workspace
load('../mat/sbgstsp.mat');                   % state-space model

%-------------------------------------%
% fig 5

fig5_name = './csv/ch4_fig5.csv';

fig5 = figure;
ax51 = subplot(1,1,1,'parent',fig5);
hold(ax51,'on');

k = linspace(0,5,256);
eig_track = zeros(5,length(k));
for ii = 1:length(k)
    dd = eig(a_mat - k(ii)*b_efd*c_v(1,:));
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:5);
end

eig_track(3,:) = eig_track(2,:);              % grouping eigenvalues into rows
eig_track(2,k<1) = eig_track(1,k<1);
eig_track(1,k<1) = eig_track(3,k<1);

di_k0 = eig_track(2,1);
[V,~] = eig(a_mat);
W = pinv(V).';                                % left eigenvectors
Ri = real(c_v(1,:)*V(:,29)*W(:,29).'*b_efd);  % residue for di_k0

plot(ax51,k,real(eig_track([1,2],:)));
plot(ax51,[0,5],[real(di_k0),real(di_k0)-5*Ri],'k--');

v = axis(ax51);
axis(ax51,[v(1),v(2),-0.06,0.04]);

legend(ax51,{'eig 1','eig 2','residue sensitivity'});
xlabel(ax51,'gain');
ylabel(ax51,'real part of eigenvalues');

H5 = {'k','mag1','mag2','ang1','ang2','re1','re2','im1','im2'};
M5 = [k; abs(eig_track([1,2],:)); (180/pi)*angle(eig_track([1,2],:));
         real(eig_track([1,2],:)); imag(eig_track([1,2],:))];

fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M5);
fclose(fid5);

% eof
