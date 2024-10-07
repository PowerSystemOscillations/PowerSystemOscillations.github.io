% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.13

% sbegstsp.mat: state-space model for d2asbeg.m

clear all; close all; clc;             % reset workspace
load('../mat/sbegstsp.mat');           % state-space model

%-------------------------------------%
% fig 13

fig13_name = './csv/ch3_fig13.csv';    % data file
spd_idx = find(mac_state(:,2)==2);     % rotor speed state index

% inter-area mode corresponds to the 25th and 26th eigenvalues
[V,D] = eig(a_mat);
V_spd = V(spd_idx,25);  % machine speed eigenvector for inter-area mode

% normalizing the eigenvector
[~,v_max] = max(abs(V_spd));
V_spd = V_spd.*((1/abs(V_spd(v_max)))*exp(-1j*angle(V_spd(v_max))));

fig13 = figure;
ax131 = subplot(1,1,1,'parent',fig13);
cp = compass(ax131,V_spd);

cmap = lines(2);
cp(1).Color = cmap(1,:);
cp(2).Color = cmap(1,:);
cp(3).Color = cmap(2,:);
cp(4).Color = cmap(2,:);

cp(2).LineStyle = '-.';
cp(4).LineStyle = '-.';

legend(ax131,['gen1'],['gen2'],['gen3'],['gen4'],'location','southEastOutside');

H13 = {'k','mag','ang','re','im'};
M13 = [1:length(V_spd); abs(V_spd).'; (180/pi)*angle(V_spd).';
       real(V_spd).'; imag(V_spd).'];

fid13 = fopen(fig13_name,'w');
fprintf(fid13,'%s,%s,%s,%s,%s\n',H13{:});
fprintf(fid13,'%6e,%6e,%6e,%6e,%6e\n',M13);
fclose(fid13);

% eof
