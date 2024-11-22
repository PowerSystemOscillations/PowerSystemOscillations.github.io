% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.29

% sbegpstsp.mat: 2-area syst. with detailed gen. models, exciters,
%                turbine/governors, and PSSs, d2asbegp.m (state space)

clear all; close all; clc;
load('../mat/sbegpstsp.mat');                 % load data file

%-------------------------------------%
% fig 29

fig29_name = './csv/ch9_fig29.csv';

egv = eig(a_mat);
figure, plot(egv,'+','linewidth',1.5)
xlabel('real'), ylabel('imaginary');
axis([-5 1 0 20]), grid on;
hold on, plot([-3 0],[3*tan(acos(0.10)) 0],'k');

% exporting data file
H29 = {'rl','im'};
M29 = [real(egv.'); imag(egv.')];

fid29 = fopen(fig29_name,'w');
fprintf(fid29,'%s,%s\n',H29{:});
fprintf(fid29,'%6e,%6e\n',M29);
fclose(fid29);

% eof
