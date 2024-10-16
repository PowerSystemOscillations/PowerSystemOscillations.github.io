% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 7.24

% 16mt3setgp16ss.mat: 16-machine system, PSSs on all generators except 1, 2

clear all; close all; clc;
load('../mat/16mt3setgp16ss.mat');

%-------------------------------------%
% fig 24

fig24_name = './csv/ch7_fig24.csv';

fig24 = figure;
ax24 = subplot(1,1,1,'parent',fig24);
hold(ax24,'on');
grid(ax24,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.08;
Td1 = 0.01;
Tn2 = 0.08;
Td2 = 0.01;

% second lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd(1,:))), -1/Td2];
a_tmp1(7,end) = 200/0.05;  % exciter gain divided by time constant

% first lead-lag stage  % (1 + 0.50s) / (1 + 0.02s)
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Td1];
a_tmp2(7,end) = (Tn2/Td2)*(200/0.05);
a_tmp2(197,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,1)), -1/Tw];
a_casc(7,end) = (Tn1/Td1)*(Tn2/Td2)*(200/0.05);
a_casc(197,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(198,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([7,197,198,199]) = [(Tn1/Td1)*(Tn2/Td2)*(200/0.05),(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                           (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:196) = c_spd(1,:);

k = linspace(0,10,11);
eig_track = zeros(199,length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp(1:199);
end

plot(ax24,[0,-5],[0,5*tan(acos(0.05))],'k');
plot(ax24,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax24,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax24,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax24,[-5,1,0,13]);

ylabel(ax24,'Imaginary (rad/s)');
xlabel(ax24,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H24 = {'k','mag','ang','re','im'};
M24 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid24 = fopen(fig24_name,'w');
fprintf(fid24,'%s,%s,%s,%s,%s\n',H24{:});
fprintf(fid24,'%6e,%6e,%6e,%6e,%6e\n',M24);
fclose(fid24);

% eof
