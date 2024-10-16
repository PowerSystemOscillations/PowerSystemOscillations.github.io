% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.11

% d16mgdcetgibss.mat: 16-machine system, SMIB model for G16, dc exciter

clear all; close all; clc;
load('../mat/d16mgdcetgibss.mat');

%-------------------------------------%
% fig 12

fig12_name = './csv/ch7_fig12.csv';

fig12 = figure;
ax12 = subplot(1,1,1,'parent',fig12);
hold(ax12,'on');

f = linspace(0.01,2,256);
w = 2*pi*f;
H = zeros(1,length(f));
a_red = a_mat(3:end,3:end);
b_red = b_vr(3:end);
c_red = c_t(16,3:end);
for ii = 1:length(f)
    H(ii) = c_red*((1j*w(ii)*eye(size(a_red)) - a_red)\b_red);
end

H_wash = freqs([10,0],[10,1],w);
H_stage1 = freqs([0.5,1],[0.02,1],w);
H_stage2 = freqs([0.5,1],[0.02,1],w);
H_comp = H_wash.*H_stage1.*H_stage2;

% plot(ax12,f,20*log10(abs(H)));
plot(ax12,f,-angle(H)*180/pi);
plot(ax12,f,angle(H_comp)*180/pi);

ylabel(ax12,'Phase (deg)');
xlabel(ax12,'Frequency (Hz)');

legend(ax12,'Ideal','Actual','location','southWest');

% exporting data file
H12 = {'f','phi','pha'};
M12 = [f; -angle(H)*180/pi; angle(H_comp)*180/pi];

fid12 = fopen(fig12_name,'w');
fprintf(fid12,'%s,%s,%s\n',H12{:});
fprintf(fid12,'%6e,%6e,%6e\n',M12);
fclose(fid12);

% eof
