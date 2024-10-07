% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.6

% sbgstsp.mat: detailed generator model with turbine governors, state-space

clear all; close all; clc;                    % reset workspace
load('../mat/sbgstsp.mat');                   % state-space model

%-------------------------------------%
% fig 6

fig6_name = './csv/ch4_fig6.csv';

fig6 = figure;
ax61 = subplot(1,1,1,'parent',fig6);
hold(ax61,'on');

k = 0:1:1001;
eig_track = zeros(size(a_mat,1),length(k));
for ii = 1:length(k)
    dd = eig(a_mat - k(ii)*b_efd*c_v(1,:));
    eig_track(:,ii) = dd;

    plot(ax61,real(dd),imag(dd),...
         'bd','markerFaceColor','b','markerSize',3.5);

    if (ii == 11)
        plot(ax61,real(dd),imag(dd),'rs','markerSize',8.5);
    end
end

dd_k0 = eig(a_mat);
plot(ax61,real(dd),imag(dd),'ro');
plot(ax61,real(dd_k0),imag(dd_k0),'r+','lineWidth',0.75);

di_k0 = dd_k0(17);                            % inter-area mode
[V,~] = eig(a_mat);
W = pinv(V).';                                % left eigenvectors
Ri = c_v(1,:)*V(:,17)*W(:,17).'*b_efd;        % residue for di_k0

plot(ax61,[real(di_k0),real(di_k0)-1000*real(Ri)],...
          [imag(di_k0),imag(di_k0)-1000*imag(Ri)],'k--');

axis(ax61,[-0.25,0.25,3.4,3.9]);
xlabel(ax61,'real (1/s)');
ylabel(ax61,'imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H6 = {'k','mag','ang','re','im'};
M6 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid6 = fopen(fig6_name,'w');
fprintf(fid6,'%s,%s,%s,%s,%s\n',H6{:});
fprintf(fid6,'%6e,%6e,%6e,%6e,%6e\n',M6);
fclose(fid6);

% eof
