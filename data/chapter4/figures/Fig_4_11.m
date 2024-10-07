% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.11

% smibncstsp.mat: nyquist analysis for single-machine infinite bus system

clear all; close all; clc;                    % reset workspace
load('../mat/smibncstsp.mat');                % state-space model

%-------------------------------------%
% fig 11

fig11_name = './csv/ch4_fig11.csv';

fig11 = figure;
ax111 = subplot(1,1,1,'parent',fig11);
hold(ax111,'on');

% cascading the lowpass filter
T = 0.05;                                     % time constant
a_casc = [a_mat, zeros(size(a_mat,1),1); (1/T)*c_v(1,:), -1/T];
b_casc = [b_exc; 0];
c_casc = zeros(1,size(a_casc,1));
c_casc(end) = 1;

k = 0:10:1000;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    K(3) = k(ii);
    [~,D] = eig(a_casc - k(ii)*b_casc*c_casc);
    eig_track(:,ii) = diag(D);
end

plot(ax111,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax111,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax111,real(eig_track(:,6)),imag(eig_track(:,6)),'rs','markerSize',8.5);
plot(ax111,real(eig_track(:,end)),imag(eig_track(:,end)),'ro');

axis(ax111,[-0.5,0.5,5,6]);
xlabel(ax111,'real (1/s)');
ylabel(ax111,'imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H11 = {'k','mag','ang','re','im'};
M11 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
       real(rl_vec); imag(rl_vec)];

fid11 = fopen(fig11_name,'w');
fprintf(fid11,'%s,%s,%s,%s,%s\n',H11{:});
fprintf(fid11,'%6e,%6e,%6e,%6e,%6e\n',M11);
fclose(fid11);

% eof
