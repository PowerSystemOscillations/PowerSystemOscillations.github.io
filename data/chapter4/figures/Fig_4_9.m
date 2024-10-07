% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.9

% sbgstsp.mat: detailed generator model with turbine governors, state-space

clear all; close all; clc;                    % reset workspace
load('../mat/sbgstsp.mat');                   % state-space model

%-------------------------------------%
% fig 9

clear all; close all; clc;

B = [0,1,-0.5,1];
A = conv(conv([1,1],[1,2]),[1,-3]);
W = 2*pi*[logspace(-3,5,1024)];               % 0.001 to 10000 Hz

H = [fliplr(freqs(B,A,W)'.'),freqs(B,A,W)];
W = [-fliplr(W),W];

fig9_name = './csv/ch4_fig9.csv';

fig9 = figure;
ax91 = subplot(1,1,1,'parent',fig9);
hold(ax91,'on');

plot(ax91,real(H),imag(H));
xlabel(ax91,'real (1/s)');
ylabel(ax91,'imaginary (rad/s)');

H9 = {'w','mag','ang','re','im'};
M9 = [W; abs(H); (180/pi)*angle(H); real(H); imag(H)];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
