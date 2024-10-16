% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.18

% d16mt3setgp11ss.mat: 16-machine system, PSSs on gens 3--6, 8--11

clear all; close all; clc;
load('../mat/d16mt3setgp11ss.mat');

%-------------------------------------%
% fig 18

fig18_name = './csv/ch7_fig18_19.csv';

fig18 = figure;
ax18 = subplot(1,1,1,'parent',fig18);
hold(ax18,'on');
grid(ax18,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.08;
Td1 = 0.01;
Tn2 = 0.08;
Td2 = 0.02;

g_idx = 8;
exc_st = find(b_vr(:,g_idx) > 10);

% second lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd(g_idx,:))), -1/Td2];
a_tmp1(exc_st,end) = 200/0.05;  % exciter gain divided by time constant

% first lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*(200/0.05);
a_tmp2(164,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,1)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*(200/0.05);
a_casc(164,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(165,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st,164,165,166]) = [(Tn1/Td1)*(Tn2/Td2)*(200/0.05),(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:163) = c_spd(g_idx,:);

k = linspace(0,100,101);
eig_track = zeros(166,length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:166);
end

plot(ax18,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax18,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax18,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax18,real(eig_track(:,4)),imag(eig_track(:,4)),'rs','markerSize',8.5);
axis(ax18,[-6,1,0,14]);

ylabel(ax18,'Imaginary (rad/s)');
xlabel(ax18,'Real');

% eof
