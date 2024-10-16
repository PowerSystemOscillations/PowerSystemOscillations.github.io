% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.11

% d16mgdcetgibss.mat: 16-machine system, SMIB model for G16, dc exciter

clear all; close all; clc;
load('../mat/d16mgdcetgibss.mat');

%-------------------------------------%
% fig 11

fig11_name = './csv/ch7_fig11.csv';

fig11 = figure;
ax11 = subplot(1,1,1,'parent',fig11);
hold(ax11,'on');

f = linspace(0.01,2,256);
w = 2*pi*f;
H = zeros(1,length(f));
a_red = a_mat(3:end,3:end);
b_red = b_vr(3:end);
c_red = c_t(16,3:end);
for ii = 1:length(f)
    H(ii) = c_red*((1j*w(ii)*eye(size(a_red)) - a_red)\b_red);
end

% plot(ax11,f,20*log10(abs(H)));
plot(ax11,f,angle(H)*180/pi);

ylabel(ax11,'Phase (deg)');
xlabel(ax11,'Frequency (Hz)');

% exporting data file
H11 = {'f','ph'};
M11 = [f; angle(H)*180/pi];

fid11 = fopen(fig11_name,'w');
fprintf(fid11,'%s,%s\n',H11{:});
fprintf(fid11,'%6e,%6e\n',M11);
fclose(fid11);

% eof
