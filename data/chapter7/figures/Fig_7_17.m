% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.17

% d16mt3setgp11ss.mat: 16-machine system, PSSs on gens 3--6, 8--11

clear all; close all; clc;
load('../mat/d16mt3setgp11ss.mat');

%-------------------------------------%
% fig 17

fig17_name = './csv/ch7_fig17.csv';

fig17 = figure;
ax17 = subplot(1,1,1,'parent',fig17);
hold(ax17,'on');

f = linspace(0.1,3,256);
w = 2*pi*f;
H = zeros(1,length(f));
H_v = zeros(1,length(f));

g_idx = 8;
g_map = 53:1:68;                              % generator index to bus map

% no angle or speed
red_mask = (mac_state(:,2) ~= 1 & mac_state(:,2) ~= 2);
a_red = a_mat(red_mask,red_mask);
b_red = b_vr(red_mask,g_idx);
c_red = c_t(g_idx,red_mask);
for ii = 1:length(f)
    H(ii) = c_red*((1j*w(ii)*eye(size(a_red)) - a_red)\b_red);
    H_v(ii) = c_v(g_map(g_idx),:)*((1j*w(ii)*eye(size(a_mat)) - a_mat)\b_vr(:,g_idx));
end

H_wash = freqs([10,0],[10,1],w);
H_stage1 = freqs([0.08,1],[0.01,1],w);
H_stage2 = freqs([0.08,1],[0.02,1],w);
H_comp = H_wash.*H_stage1.*H_stage2;

plot(ax17,f,-angle(H)*180/pi);
plot(ax17,f,angle(H_comp)*180/pi);
plot(ax17,f,-angle(H_v)*180/pi);
% axis(ax17,[0,2,0,50]);
axis(ax17,[0,3,0,120]);

legend(ax17,{'Ideal','Actual','Term. voltage'},'location','southEast');

ylabel(ax17,'Phase (deg)');
xlabel(ax17,'Frequency (Hz)');

% exporting data file
H17 = {'f','phi','phv','pha'};
M17 = [f; -angle(H)*180/pi; -angle(H_v)*180/pi; angle(H_comp)*180/pi];

fid17 = fopen(fig17_name,'w');
fprintf(fid17,'%s,%s,%s,%s\n',H17{:});
fprintf(fid17,'%6e,%6e,%6e,%6e\n',M17);
fclose(fid17);

% eof
