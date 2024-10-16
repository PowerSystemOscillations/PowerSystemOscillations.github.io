% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.6

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% fig 6

fig6_name = './csv/ch7_fig6.csv';

fig6 = figure;
ax6 = subplot(1,1,1,'parent',fig6);
hold(ax6,'on');

f = linspace(0.1,2,256);
w = 2*pi*f;
H = zeros(1,length(f));
a_red = a_mat(3:end,3:end);
b_red = b_vr(3:end);
c_red = c_t(16,3:end);
for ii = 1:length(f)
    H(ii) = c_red*((1j*w(ii)*eye(size(a_red)) - a_red)\b_red);
end

% plot(ax6,f,20*log10(abs(H)));
plot(ax6,f,angle(H)*180/pi);

ylabel(ax6,'Phase (deg)');
xlabel(ax6,'Frequency (Hz)');

% exporting data file
H6 = {'f','ph'};
M6 = [f; angle(H)*180/pi];

fid6 = fopen(fig6_name,'w');
fprintf(fid6,'%s,%s\n',H6{:});
fprintf(fid6,'%6e,%6e\n',M6);
fclose(fid6);

% eof
