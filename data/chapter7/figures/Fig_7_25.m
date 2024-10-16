% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.25

% 16mt3setgp1ss.mat: 16-machine system, PSSs on all generators except 2

clear all; close all; clc;
load('../mat/16mt3setgp1ss.mat');

%-------------------------------------%
% fig 25

fig25_name = './csv/ch7_fig25.csv';

fig25 = figure;
ax25 = subplot(1,1,1,'parent',fig25);
hold(ax25,'on');
grid(ax25,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.08;
Td1 = 0.01;
Tn2 = 0.08;
Td2 = 0.01;

g_idx = 2;
exc_st = find(b_vr(:,g_idx) > 10);

% second lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd(g_idx,:))), -1/Td2];
a_tmp1(exc_st,end) = 200/0.05;  % exciter gain divided by time constant

% first lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*(200/0.05);
a_tmp2(200,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,1)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*(200/0.05);
a_casc(200,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(201,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st,200,201,202]) = [(Tn1/Td1)*(Tn2/Td2)*(200/0.05),(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:199) = c_spd(g_idx,:);

k = linspace(0,10,11);
eig_track = zeros(202,length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:202);
end

plot(ax25,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax25,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax25,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax25,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax25,[-5,1,0,13]);

ylabel(ax25,'Imaginary (rad/s)');
xlabel(ax25,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H25 = {'k','mag','ang','re','im'};
M25 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid25 = fopen(fig25_name,'w');
fprintf(fid25,'%s,%s,%s,%s,%s\n',H25{:});
fprintf(fid25,'%6e,%6e,%6e,%6e,%6e\n',M25);
fclose(fid25);

% eof
