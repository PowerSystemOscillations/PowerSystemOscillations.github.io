% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.9

% d16mt1segibss.mat: 16-machine system where all gens except G16 are infinite buses

clear all; close all; clc;
load('../mat/d16mt1segibss.mat');

%-------------------------------------%
% fig 9

fig9_name = './csv/ch7_fig9.csv';

fig9 = figure;
ax9 = subplot(1,1,1,'parent',fig9);
hold(ax9,'on');
grid(ax9,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.03;
Td1 = 0.01;
Tn2 = 0.04;
Td2 = 0.01;

g_idx = 1;
exc_st = find(b_vr(:,g_idx) > 10);

% second lead-lag stage  % (1 + 0.04s) / (1 + 0.01s)
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd)), -1/Td2];
a_tmp1(exc_st,end) = 200/0.05;  % exciter gain divided by time constant

% first lead-lag stage  % (1 + 0.03s) / (1 + 0.01s)
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*(200/0.05);
a_tmp2(11,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,1)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*(200/0.05);
a_casc(11,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(12,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st,11,12,13]) = [(Tn1/Td1)*(Tn2/Td2)*(200/0.05),(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                             (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:10) = c_spd;

k = linspace(0,100,101);
eig_track = zeros(10,length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:10);
end

plot(ax9,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax9,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax9,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax9,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax9,[-10,1,0,20]);

ylabel(ax9,'Imaginary (rad/s)');
xlabel(ax9,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H9 = {'k','mag','ang','re','im'};
M9 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
