% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.15

% 16mt3setgss.mat: 16-machine system, static exciters, state-space

clear all; close all; clc;
load('../mat/16mt3setgss.mat');

%-------------------------------------%
% fig 15

fig15_name = './csv/ch7_fig15.csv';

fig15 = figure;
ax15 = subplot(1,1,1,'parent',fig15);
hold(ax15,'on');
grid(ax15,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.08;
Td1 = 0.03;
Tn2 = 0.05;
Td2 = 0.01;

g_idx = 11;
exc_st = find(b_vr(:,g_idx) > 10);

% second lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd(g_idx,:))), -1/Td2];
a_tmp1(exc_st,end) = 200/0.05;  % exciter gain divided by time constant

% first lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*(200/0.05);
a_tmp2(161,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,1)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*(200/0.05);
a_casc(161,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(162,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st,161,162,163]) = [(Tn1/Td1)*(Tn2/Td2)*(200/0.05),(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:160) = c_spd(g_idx,:);

k = linspace(0,100,101);
eig_track = zeros(163,length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:163);
end

plot(ax15,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax15,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax15,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax15,real(eig_track(:,4)),imag(eig_track(:,4)),'rs','markerSize',8.5);
axis(ax15,[-5,1,0,14]);

ylabel(ax15,'Imaginary (rad/s)');
xlabel(ax15,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H15 = {'k','mag','ang','re','im'};
M15 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid15 = fopen(fig15_name,'w');
fprintf(fid15,'%s,%s,%s,%s,%s\n',H15{:});
fprintf(fid15,'%6e,%6e,%6e,%6e,%6e\n',M15);
fclose(fid15);

% eof
