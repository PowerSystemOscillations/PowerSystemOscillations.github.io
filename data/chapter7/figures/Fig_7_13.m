% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.13

% d16mgdcetgibss.mat: 16-machine system, SMIB model for G16, dc exciter

clear all; close all; clc;
load('../mat/d16mgdcetgibss.mat');

%-------------------------------------%
% fig 13

fig13_name = './csv/ch7_fig13.csv';

fig13 = figure;
ax13 = subplot(1,1,1,'parent',fig13);
hold(ax13,'on');
grid(ax13,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.50;
Td1 = 0.02;
Tn2 = 0.50;
Td2 = 0.02;

g_idx = 1;
exc_st = find(b_vr(:,g_idx) > 10);

% second lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd)), -1/Td2];
a_tmp1(exc_st,end) = 40/0.02;  % exciter gain divided by time constant

% first lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*(40/0.02);
a_tmp2(13,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,1)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*(40/0.02);
a_casc(13,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(14,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st,13,14,15]) = [(Tn1/Td1)*(Tn2/Td2)*(40/0.02),(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                        (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:12) = c_spd;

k = linspace(0,100,101);
eig_track = zeros(10,length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:10);
end

plot(ax13,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax13,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax13,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax13,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax13,[-5,1,0,5]);

ylabel(ax13,'Imaginary (rad/s)');
xlabel(ax13,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H13 = {'k','mag','ang','re','im'};
M13 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid13 = fopen(fig13_name,'w');
fprintf(fid13,'%s,%s,%s,%s,%s\n',H13{:});
fprintf(fid13,'%6e,%6e,%6e,%6e,%6e\n',M13);
fclose(fid13);

% eof
