% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 9.12

% sbstsp.mat: 2-area syst. with detailed gen. models d2asb.m (state space)

clear all; close all; clc;                    % reset workspace
run('../cases/d2asb.m');
load('../mat/sbstsp.mat');                    % load data file

%-------------------------------------%
% fig 12

fig12ab1314_name = './csv/ch9_fig12ab_13_14.csv';
fig12c_name = './csv/ch9_fig12c.csv';
fig12d_name = './csv/ch9_fig12d.csv';

% create b_Efd input columns
[n1,n2] = size(a_mat);
b_Efd = zeros(n1,4);
for i = 1:4
    b_Efd((i-1)*6 + 3,i) = 1/mac_con(i,9);
end

% 6-input, 4-output system
G = ss(a_mat,[b_Efd b_lmod],[c_v([3 8],:); c_ang([3 8],:)],zeros(4,6));
% add rate filter to obtain c_f
rate = tf([1 0],(2*pi*60)*[0.01 1]);
G_vf = [1 0 0 0; 0 1 0 0; 0 0 rate 0; 0 0 0 rate]*G;

% scaling of inputs and outputs according to (9.17) p. 214
b_scaled = G_vf.b * diag([10,10,10,10,0.1,0.1]);
c_scaled = diag([20,20,1000,1000]) * G_vf.c;
G_scaled = ss(G_vf.a,b_scaled,c_scaled,G_vf.d);

% fig 12 singular value plots

fig12 = figure;
for ii = 1:4
    ax12{ii} = subplot(2,2,ii,'parent',fig12);
    hold(ax12{ii},'on');
end

% we have to separate the inputs and outputs into 4 different plots
% TF 1
G_scaled_em = ss(G_scaled.a, G_scaled.b(:,1:4), G_scaled.c(1:2,:), ...
                 G_scaled.d(1:2,1:4));
% figure, sigma(G_scaled_em);
[SV_em,W_em] = sigma(G_scaled_em,{1e-2,1e3});
cn_em = SV_em(1,:)./SV_em(2,:);               % condition number
plot(ax12{1},W_em/(2*pi),[SV_em; cn_em]);

% TF 2
G_scaled_ef = ss(G_scaled.a, G_scaled.b(:,1:4), G_scaled.c(3:4,:), ...
                 G_scaled.d(3:4,1:4));
% figure, sigma(G_scaled_ef)
[SV_ef,W_ef] = sigma(G_scaled_ef,{1e-2,1e3});
cn_ef = SV_ef(1,:)./SV_ef(2,:);               % condition number
plot(ax12{2},W_ef/(2*pi),[SV_ef; cn_ef]);

% TF 3
G_scaled_lm = ss(G_scaled.a, G_scaled.b(:,5:6), G_scaled.c(1:2,:), ...
                 G_scaled.d(1:2,5:6));
% figure, sigma(G_scaled_lm)
[SV_lm,W_lm] = sigma(G_scaled_lm,{1e-2,1e3});
cn_lm = SV_lm(1,:)./SV_lm(2,:);               % condition number
plot(ax12{3},W_lm/(2*pi),[SV_lm; cn_lm]);

% TF 4
G_scaled_lf = ss(G_scaled.a, G_scaled.b(:,5:6), G_scaled.c(3:4,:), ...
                 G_scaled.d(3:4,5:6));
% figure, sigma(G_scaled_lf)
[SV_lf,W_lf] = sigma(G_scaled_lf,{1e-2,1e3});
cn_lf = SV_lf(1,:)./SV_lf(2,:);               % condition number
plot(ax12{4},W_lf/(2*pi),[SV_lf; cn_lf]);

for ii = 1:4
    legend(ax12{ii},'smx','smn','cn','location','best');
    set(ax12{ii},'xscale','log');
    set(ax12{ii},'yscale','log');
    axis(ax12{ii},[0.01 100 1e-5 1e5]);
end

% ylabel(ax121,'Freq. dev. (pu)');
% ylabel(ax92,'Freq. dev. (pu)');
title(ax12{1},'a');
title(ax12{2},'b');
title(ax12{3},'c');
title(ax12{4},'d');
%
xlabel(ax12{3},'Frequency (Hz)');
xlabel(ax12{4},'Frequency (Hz)');

% exporting data file
H12ab1314 = {'wem','wef', ...
    'svemx','svemn','cnem', ...
    'svefx','svefn','cnef'};
M12ab1314 = [W_em.'/(2*pi); W_ef.'/(2*pi); ...
    SV_em(1,:); SV_em(2,:); cn_em; ...
    SV_ef(1,:); SV_ef(2,:); cn_ef;];

fid12ab1314 = fopen(fig12ab1314_name,'w');
fprintf(fid12ab1314,'%s,%s,%s,%s,%s,%s,%s,%s\n',H12ab1314{:});
fprintf(fid12ab1314,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M12ab1314);
fclose(fid12ab1314);

H12c = {'wlm','svlmx','svlmn','cnlm'};
M12c = [W_lm.'/(2*pi); SV_lm(1,:); SV_lm(2,:); cn_lm;];

fid12c = fopen(fig12c_name,'w');
fprintf(fid12c,'%s,%s,%s,%s\n',H12c{:});
fprintf(fid12c,'%6e,%6e,%6e,%6e\n',M12c);
fclose(fid12c);

H12d = {'wlf','svlfx','svlfn','cnlf'};
M12d = [W_lf.'/(2*pi); SV_lf(1,:); SV_lf(2,:); cn_lf;];

fid12d = fopen(fig12d_name,'w');
fprintf(fid12d,'%s,%s,%s,%s\n',H12d{:});
fprintf(fid12d,'%6e,%6e,%6e,%6e\n',M12d);
fclose(fid12d);

% eof
