% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.7

% sbgstsp.mat: detailed generator model with turbine governors, state-space

clear all; close all; clc;                    % reset workspace
load('../mat/sbgstsp.mat');                   % state-space model

%-------------------------------------%
% fig 7

fig7_name = './csv/ch4_fig7.csv';

fig7 = figure;
ax71 = subplot(1,1,1,'parent',fig7);
hold(ax71,'on');

% cascading the system with the 2nd-order lowpass filter
T1 = 0.01;  % 1st time constant
T2 = 0.05;  % 2nd time constant
%
a_stage1 = [a_mat, zeros(size(a_mat,1),1); (1/T1)*c_v(1,:), -1/T1];
b_stage1 = [b_efd; 0];
c_stage1 = zeros(1,size(a_stage1,1));
c_stage1(end) = 1;
%
a_stage2 = [a_stage1, zeros(size(a_stage1,1),1); (1/T2)*c_stage1(1,:), -1/T2];
b_stage2 = [b_stage1; 0];
c_stage2 = zeros(1,size(a_stage2,1));
c_stage2(end) = 1;

k = 0:1:1001;
eig_track = zeros(size(a_stage2,1),length(k));
for ii = 1:length(k)
    dd = eig(a_stage2 - k(ii)*b_stage2*c_stage2);
    eig_track(:,ii) = dd;

    plot(ax71,real(dd),imag(dd),...
         'bd','markerFaceColor','b','markerSize',3.5);

    if (ii == 11)
        plot(ax71,real(dd),imag(dd),'rs','markerSize',8.5);
    end
end

dd_k0 = eig(a_stage2);
plot(ax71,real(dd),imag(dd),'ro');
plot(ax71,real(dd_k0),imag(dd_k0),'r+','lineWidth',0.75);

di_k0 = dd_k0(19);                            % inter-area mode
[V,~] = eig(a_stage2);
W = pinv(V).';                                % left eigenvectors

% residue for di_k0
Ri = c_stage2(1,:)*V(:,19)*W(:,19).'*b_stage2;

plot(ax71,[real(di_k0),real(di_k0)-1000*real(Ri)],...
          [imag(di_k0),imag(di_k0)-1000*imag(Ri)],'k--');

axis(ax71,[-0.25,0.25,3.4,3.9]);
xlabel(ax71,'real (1/s)');
ylabel(ax71,'imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H7 = {'k','mag','ang','re','im'};
M7 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid7 = fopen(fig7_name,'w');
fprintf(fid7,'%s,%s,%s,%s,%s\n',H7{:});
fprintf(fid7,'%6e,%6e,%6e,%6e,%6e\n',M7);
fclose(fid7);

% eof
