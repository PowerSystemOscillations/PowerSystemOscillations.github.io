% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.7

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% fig 7

fig7_name = './csv/ch7_fig7.csv';

fig7 = figure;
ax7 = subplot(1,1,1,'parent',fig7);
hold(ax7,'on');

f = linspace(0.1,2,256);
w = 2*pi*f;
H = zeros(1,length(f));
a_red = a_mat(3:end,3:end);
b_red = b_vr(3:end);
c_red = c_t(16,3:end);
for ii = 1:length(f)
    H(ii) = c_red*((1j*w(ii)*eye(size(a_red)) - a_red)\b_red);
end

H_wash = freqs([10,0],[10,1],w);
H_stage1 = freqs([0.03,1],[0.01,1],w);
H_stage2 = freqs([0.04,1],[0.01,1],w);
H_comp = H_wash.*H_stage1.*H_stage2;

% plot(ax7,f,20*log10(abs(H)));
plot(ax7,f,-angle(H)*180/pi);
plot(ax7,f,angle(H_comp)*180/pi);

legend(ax7,'Ideal','Actual','location','southEast');

ylabel(ax7,'Phase (deg)');
xlabel(ax7,'Frequency (Hz)');

% exporting data file
H7 = {'f','phi','pha'};
M7 = [f; -angle(H)*180/pi; angle(H_comp)*180/pi];

fid7 = fopen(fig7_name,'w');
fprintf(fid7,'%s,%s,%s\n',H7{:});
fprintf(fid7,'%6e,%6e,%6e\n',M7);
fclose(fid7);

% eof
