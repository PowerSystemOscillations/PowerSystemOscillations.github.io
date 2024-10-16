% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.14

% 16mt3setgss.mat: 16-machine system, static exciters, state-space

clear all; close all; clc;
load('../mat/16mt3setgss.mat');

%-------------------------------------%
% fig 14

fig14_name = './csv/ch7_fig14.csv';

fig14 = figure;
ax14 = subplot(1,1,1,'parent',fig14);
hold(ax14,'on');

f = linspace(0.1,3,256);
w = 2*pi*f;
H = zeros(1,length(f));
H_v = zeros(1,length(f));
red_mask = (mac_state(:,2) ~= 1 & mac_state(:,2) ~= 2);
a_red = a_mat(red_mask,red_mask);
b_red = b_vr(red_mask,11);
c_red = c_t(11,red_mask);
for ii = 1:length(f)
    H(ii) = c_red*((1j*w(ii)*eye(size(a_red)) - a_red)\b_red);
    H_v(ii) = c_v(63,:)*((1j*w(ii)*eye(size(a_mat)) - a_mat)\b_vr(:,11));
end

H_wash = freqs([10,0],[10,1],w);
H_stage1 = freqs([0.08,1],[0.03,1],w);
H_stage2 = freqs([0.05,1],[0.01,1],w);
H_comp = H_wash.*H_stage1.*H_stage2;

% plot(ax14,f,20*log10(abs(H)));
plot(ax14,f,-angle(H)*180/pi);
plot(ax14,f,angle(H_comp)*180/pi);
plot(ax14,f,-angle(H_v)*180/pi);
axis(ax14,[0,3,-50,100]);

legend(ax14,{'Ideal','Actual','Term. voltage'},'location','southWest');

ylabel(ax14,'Phase (deg)');
xlabel(ax14,'Frequency (Hz)');

% exporting data file
H14 = {'f','phi','phv','pha'};
M14 = [f; -angle(H)*180/pi; -angle(H_v)*180/pi; angle(H_comp)*180/pi];

fid14 = fopen(fig14_name,'w');
fprintf(fid14,'%s,%s,%s\n',H14{:});
fprintf(fid14,'%6e,%6e,%6e\n',M14);
fclose(fid14);

% eof
