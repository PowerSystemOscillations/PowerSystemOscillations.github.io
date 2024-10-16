% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.4

% datalaag_smib_tor.mat:

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

%-------------------------------------%
% fig 4

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_spd = smib_tor.c_spd;

n = size(a_mat,1);

fig4_name = './csv/ch8_fig4.csv';

fig4 = figure;
ax41 = subplot(2,1,1,'parent',fig4);
ax42 = subplot(2,1,2,'parent',fig4);
hold(ax41,'on');
hold(ax42,'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

exc_st = find(b_vr > 10);

% lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(size(c_spd)), -1/Td1];
a_tmp1(exc_st,end) = b_vr(exc_st);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,1)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*b_vr(exc_st);
a_casc(n+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2]) = [(Tn1/Td1)*b_vr(exc_st); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

f = logspace(0,2,401);
w = 2*pi*f;
H = zeros(1,length(f));
H_casc = zeros(1,length(f));
for ii = 1:length(f)
    H(ii) = c_spd*((1j*w(ii)*eye(size(a_mat)) - a_mat)\b_vr);
    H_casc(ii) = c_casc*((1j*w(ii)*eye(size(a_casc)) - a_casc)\b_casc);
end

plot(ax41,f,20*log10(abs(H_casc)));
plot(ax42,f,angle(H_casc)*180/pi);
set(ax41,'xscale','log');
set(ax42,'xscale','log');
axis(ax41,[1,100,-140,20]);

% legend(ax41,'model','analytical','location','southEast');

ylabel(ax41,'Gain (dB)');
ylabel(ax42,'Phase (deg)');
xlabel(ax42,'Frequency (Hz)');
v = axis(ax41);
axis(ax41,[v(1),v(2),-105,25]);
v = axis(ax42);
axis(ax42,[v(1),v(2),-185,185]);

% exporting data file
H4 = {'f','g','ph'};
M4 = [f; 20*log10(abs(H_casc)); angle(H_casc)*180/pi];

fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s\n',H4{:});
fprintf(fid4,'%6e,%6e,%6e\n',M4);
fclose(fid4);

% eof
