% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.18

% datalam_stsp.mat: 4-generator infinite bus plant model, state-space

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

%-------------------------------------%
% fig 18

fig18_name = './csv/ch8_fig18.csv';

fig18 = figure;
ax18 = subplot(1,1,1,'parent',fig18);
hold(ax18,'on');

f = linspace(0.1,3,256);
w = 2*pi*f;
G = zeros(1,length(f));
G_v = zeros(1,length(f));

g_idx = 1;
g_map = 2;                                    % generator index to bus map

% no angle or speed
red_mask = (mac_state(:,2) ~= 1 & mac_state(:,2) ~= 2);
a_red = a_mat(red_mask,red_mask);
b_red = b_vr(red_mask,g_idx);
c_red = c_t(g_idx,red_mask);
for ii = 1:length(f)
    H(ii) = c_red*((1j*w(ii)*eye(size(a_red)) - a_red)\b_red);
    H_v(ii) = c_v(g_map(g_idx),:)*((1j*w(ii)*eye(size(a_mat)) - a_mat)\b_vr(:,g_idx));
end

H_wash = [freqs([1.41,0],[1.41,1],w); freqs([1.41,0],[1.41,1],w); ...
          freqs([10,0],[10,1],w); freqs([5,0],[5,1],w)];
H_stage1 = [freqs([0.154,1],[0.033,1],w); freqs([0.4,1],[0.3,1],w); ...
            freqs([0.05,1],[0.01,1],w); freqs([0.1,1],[0.01,1],w)];
H_stage2 = [ones(size(w)); ones(size(w)); ...
            freqs([0.05,1],[0.01,1],w); freqs([0.1,1],[0.01,1],w)];

H_comp = H_wash.*H_stage1.*H_stage2;

plot(ax18,f,-angle(H)*180/pi);
plot(ax18,f,angle(H_comp)*180/pi);
axis(ax18,[0,2,0,120]);

legend(ax18,{'Ideal','Stab1','Stab2','Stab3','Stab4'},'location','northWest');

ylabel(ax18,'Phase (deg)');
xlabel(ax18,'Frequency (Hz)');

% exporting data file
H18 = {'f','phi','pha1','pha2','pha3','pha4'};
M18 = [f; -angle(H)*180/pi; angle(H_comp)*180/pi];

fid18 = fopen(fig18_name,'w');
fprintf(fid18,'%s,%s,%s,%s,%s,%s\n',H18{:});
fprintf(fid18,'%6e,%6e,%6e,%6e,%6e,%6e\n',M18);
fclose(fid18);

% eof
