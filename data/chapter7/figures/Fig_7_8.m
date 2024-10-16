% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.8

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% fig 8

fig8_name = './csv/ch7_fig8.csv';

fig8 = figure;
ax8 = subplot(1,1,1,'parent',fig8);
hold(ax8,'on');

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

% plot(ax8,f,20*log10(abs(H)));
plot(ax8,f,-angle(H)*180/pi);
plot(ax8,f,angle(H_wash)*180/pi);

ylabel(ax8,'Phase (deg)');
xlabel(ax8,'Frequency (Hz)');

legend(ax8,'Ideal','Washout only','location','east');

% exporting data file
H8 = {'f','phi','phw'};
M8 = [f; -angle(H)*180/pi; angle(H_wash)*180/pi];

fid8 = fopen(fig8_name,'w');
fprintf(fid8,'%s,%s,%s\n',H8{:});
fprintf(fid8,'%6e,%6e,%6e\n',M8);
fclose(fid8);

% eof
