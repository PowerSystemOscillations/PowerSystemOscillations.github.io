% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.32

% sbegpstsp.mat: 2-area syst. with detailed gen. models, exciters,
%                turbine/governors, and PSSs, d2asbegp.m (state space)

clear all; close all; clc;
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 32

fig32_name = './csv/ch9_fig32.csv';

b_tg = 25*b_pr;
W1e = 0.1*tf([0.1584 1],[0.001584 1]);
W1g = 0.1*tf([0.1584 1],[0.01584 1]);
W1em = [W1e 0 0 0; 0 W1e 0 0; 0 0 W1e 0; 0 0 0 W1e];
W1gm = [W1g 0 0 0; 0 W1g 0 0; 0 0 W1g 0; 0 0 0 W1g];
W1 = [W1em zeros(4,4); zeros(4,4) W1gm];

% Add frequency weights to G8
G_8 = ss(a_mat,[0.05*b_vr 0.001*b_tg], ...
         [20*c_v([1 2 6 7],:); 1000*c_spd], zeros(8,8));
G_8w = W1*G_8;
[SV_G8w,W_G8w] = sigma(G_8w,{1e-2,1e3});
figure, loglog(W_G8w/(2*pi),SV_G8w(1,:));
%title('Maximum singular value of N11 for robust stability analysis')
axis([0.01 100 1e-3 1e0]);
xlabel('Frequency (Hz)');

% exporting data file
H32 = {'wg8w','svg8w'};
M32 = [W_G8w.'/(2*pi); SV_G8w(1,:)];

fid32 = fopen(fig32_name,'w');
fprintf(fid32,'%s,%s\n',H32{:});
fprintf(fid32,'%6e,%6e\n',M32);
fclose(fid32);

% eof
