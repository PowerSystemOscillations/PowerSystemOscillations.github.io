% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.2

% datalaag_smib_tor.mat:

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

%-------------------------------------%
% fig 2

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_spd = smib_tor.c_spd;

n = size(a_mat,1);

fig2_name = './csv/ch8_fig2.csv';

fig2 = figure;
ax2 = subplot(1,1,1,'parent',fig2);
hold(ax2,'on');
grid(ax2,'on');

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

k = [0:1:99,logspace(2,4,200),1e9];
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax2,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax2,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax2,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax2,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',6.5);
plot(ax2,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax2,[-25,25,0,300]);
% axis(ax3,[-3.0,1.0,0,12]);

ylabel(ax2,'Imaginary (rad/s)');
xlabel(ax2,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H2 = {'k','mag','ang','re','im'};
M2 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid2 = fopen(fig2_name,'w');
fprintf(fid2,'%s,%s,%s,%s,%s\n',H2{:});
fprintf(fid2,'%6e,%6e,%6e,%6e,%6e\n',M2);
fclose(fid2);

%% figs 3 - plant mode root locus

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_spd = smib_tor.c_spd;

n = size(a_mat,1);

fig3_name = './csv/ch8_fig3.csv';

fig3 = figure;
ax3 = subplot(1,1,1,'parent',fig3);
hold(ax3,'on');
grid(ax3,'on');

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

k = [0:1:150,1e9];
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax3,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax3,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax3,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax3,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',6.5);
% plot(ax3,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax3,[-2.5,1.0,0,10]);

ylabel(ax3,'Imaginary (rad/s)');
xlabel(ax3,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H3 = {'k','mag','ang','re','im'};
M3 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid3 = fopen(fig3_name,'w');
fprintf(fid3,'%s,%s,%s,%s,%s\n',H3{:});
fprintf(fid3,'%6e,%6e,%6e,%6e,%6e\n',M3);
fclose(fid3);

%% fig 4 - frequency response

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

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

% exporting data file
H4 = {'f','g','ph'};
M4 = [f; 20*log10(abs(H_casc)); angle(H_casc)*180/pi];

fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s\n',H4{:});
fprintf(fid4,'%6e,%6e,%6e\n',M4);
fclose(fid4);

%% fig 5 - torsional filter frequency response

clear all; close all; clc;

fig5_name = './csv/ch8_fig5.csv';

fig5 = figure;
ax51 = subplot(2,1,1,'parent',fig5);
ax52 = subplot(2,1,2,'parent',fig5);
hold(ax51,'on');
hold(ax52,'on');

w02 = [1.024050e+02, 1.514296e+02, 1.904670e+02, 2.764385e+02].^2;
betaf = 1./w02;
alphaf = [0.005, 0.001, 0.0005, 0.0001];
gammaf = [5e-7, 5e-7, 5e-7, 5e-7];

btf = [betaf(1),gammaf(1),1];                 % numerator
atf = [betaf(1),alphaf(1),1];                 % denominator
for ii = 2:length(w02)
    btf = conv(btf,[betaf(ii),gammaf(ii),1]);
    atf = conv(atf,[betaf(ii),alphaf(ii),1]);
end

[H,w] = freqs(btf,atf,2*pi*logspace(0,2,512));
f = w/2/pi;

plot(ax51,f,20*log10(abs(H)));
plot(ax52,f,(180/pi)*phase(H));

set(ax51,'xscale','log');
set(ax52,'xscale','log');
axis(ax51,[1,100,-50,5]);
axis(ax52,[1,100,-200,200]);

ylabel(ax51,'Gain (dB)');
ylabel(ax52','Phase (deg)');
xlabel(ax52,'Frequency (Hz)');

% exporting data file
H5 = {'f','g','ph'};
M5 = [f; 20*log10(abs(H)); angle(H)*180/pi];

fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e\n',M5);
fclose(fid5);

%% fig 6 and 7 - root locus with torsional filter

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_spd = smib_tor.c_spd;

n = size(a_mat,1);

fig6_name = './csv/ch8_figs6_7.csv';

fig6 = figure;
ax6 = subplot(1,1,1,'parent',fig6);
hold(ax6,'on');

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

sys_speed_pss = ss(a_casc,b_casc,c_casc,0);

w02 = [1.024050e+02, 1.514296e+02, 1.904670e+02, 2.764385e+02].^2;
betaf = 1./w02;
alphaf = [0.005, 0.001, 0.0005, 0.0001];
gammaf = [5e-7, 5e-7, 5e-7, 5e-7];

btf = [betaf(1),gammaf(1),1];                 % numerator
atf = [betaf(1),alphaf(1),1];                 % denominator
for ii = 2:length(w02)
    btf = conv(btf,[betaf(ii),gammaf(ii),1]);
    atf = conv(atf,[betaf(ii),alphaf(ii),1]);
end

sys_tor_filt = tf(btf,atf);                   % torsional filter
sys_pss_tor_filt = series(sys_speed_pss,sys_tor_filt);

k = [0:1:150];
eig_track = zeros(size(sys_pss_tor_filt.A,1),length(k));
for ii = 1:length(k)
    dd = eig(sys_pss_tor_filt.A + k(ii)*sys_pss_tor_filt.B*sys_pss_tor_filt.C);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

filter_zeros = zeros(length(betaf),1);
for ii = 1:length(betaf)
    tmp = roots([betaf(ii),gammaf(ii),1]);
    filter_zeros(ii) = real(tmp(1));
end

plot(ax6,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax6,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax6,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
plot(ax6,filter_zeros,sqrt(w02),'ro','markerSize',6.5);
axis(ax6,[-0.05,0.05,90,300]);

fig7 = figure;
ax7 = subplot(1,1,1,'parent',fig7);
hold(ax7,'on');
grid(ax7,'on');

plot(ax7,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax7,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax7,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax7,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax7,[-2.5,1.0,0,10]);

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H6 = {'k','mag','ang','re','im'};
M6 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid6 = fopen(fig6_name,'w');
fprintf(fid6,'%s,%s,%s,%s,%s\n',H6{:});
fprintf(fid6,'%6e,%6e,%6e,%6e,%6e\n',M6);
fclose(fid6);

%% fig 8 - frequency response of the electrical power

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_p = smib_tor.c_p(1,:);

fig8_name = './csv/ch8_fig8.csv';

fig8 = figure;
ax81 = subplot(2,1,1,'parent',fig8);
ax82 = subplot(2,1,2,'parent',fig8);
hold(ax81,'on');
hold(ax82,'on');

H = 3.558;                                    % inertia constant

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

Hpss = tf([Tw,0],[Tw,1])*tf([Tn1,1],[Td1,1]);
Gp = ss(a_mat,b_vr,c_p,0);
Gp = series(Gp,[tf([0,1],[1,0])]);
Gpss = series(Hpss,Gp);

f = logspace(0,2,256);
w = 2*pi*f;
H_casc = zeros(1,length(f));
for ii = 1:length(f)
    H_casc(ii) = Gpss.C*((1j*w(ii)*eye(size(Gpss.A)) - Gpss.A)\Gpss.B);
end

plot(ax81,f,20*log10(abs(H_casc)));
plot(ax82,f,angle(H_casc)*180/pi);
set(ax81,'xscale','log');
set(ax82,'xscale','log');
% axis(ax81,[1,100,-140,0]);

% legend(ax81,'model','analytical','location','southEast');

ylabel(ax81,'Gain (dB)');
ylabel(ax82,'Phase (deg)');
xlabel(ax82,'Frequency (Hz)');

axis(ax81,[1,100,-100,20]);

% exporting data file
H8 = {'f','g','ph'};
M8 = [f; 20*log10(abs(H_casc)); angle(H_casc)*180/pi];

fid8 = fopen(fig8_name,'w');
fprintf(fid8,'%s,%s,%s\n',H8{:});
fprintf(fid8,'%6e,%6e,%6e\n',M8);
fclose(fid8);

%% figs 9 and 10 - frequency response

clear all; close all; clc;
load('../mat/datalaag_smib_tor.mat');

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_p = smib_tor.c_p(1,:);

fig9_name = './csv/ch8_figs9_10.csv';

fig9 = figure;
ax9 = subplot(1,1,1,'parent',fig9);
hold(ax9,'on');
grid(ax9,'on');

H = 3.558;                                    % inertia constant

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

Hpss = tf([Tw,0],[Tw,1])*tf([Tn1,1],[Td1,1]);
Gp = ss(a_mat,b_vr,c_p,0);
Gp = series(Gp,[tf([0,1],[1,0])]);
Gpss = series(Hpss,Gp);

k = 0:1:150;
eig_track = zeros(size(Gpss.A,1),length(k));
for ii = 1:length(k)
    dd = eig(Gpss.A - (k(ii)/(2*H))*Gpss.B*Gpss.C);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax9,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax9,real(eig_track(:,1:40)),imag(eig_track(:,1:40)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax9,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax9,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
axis(ax9,[-0.2,0.2,90,300]);

ylabel(ax9,'Imaginary (rad/s)');
xlabel(ax9,'Real');

fig10 = figure;
ax10 = subplot(1,1,1,'parent',fig10);
hold(ax10,'on');
grid(ax10,'on');

plot(ax10,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax10,real(eig_track),imag(eig_track),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax10,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax10,real(eig_track(:,11)),imag(eig_track(:,11)),'rs','markerSize',8.5);
% axis(ax10,[-25,25,0,300]);
axis(ax10,[-2.5,1.0,0,10]);

ylabel(ax10,'Imaginary (rad/s)');
xlabel(ax10,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H9 = {'k','mag','ang','re','im'};
M9 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

%% fig 11 - step response

clear all; close all; clc;
load('../mat/datalaag_smib.mat');

a_mat = smib.a_mat;
b_vr = smib.b_vr;

fig11_name = './csv/ch8_fig11.csv';

fig11 = figure;
ax11{1} = subplot(2,1,1,'parent',fig11);
ax11{2} = subplot(2,1,2,'parent',fig11);
hold(ax11{1},'on');
hold(ax11{2},'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

Hpss = tf([Tw,0],[Tw,1])*tf([Tn1,1],[Td1,1]);
Gspd = ss(a_mat,b_vr,[smib.c_spd;smib.c_v],0);
Gpss = series(Hpss,Gspd,1,1);

H = 3.558;                                    % inertia constant
K = 10;                                       % control gain
Fs = 240;                                     % sampling frequency
ts = 0:1/Fs:10;
n_step = length(ts);

u = ts;                                       % 1 pu/s ramp
u(u > 1) = 1;
xa = zeros(size(Gpss.A,1),n_step);
dxa = zeros(size(Gpss.A,1),n_step);
ya = zeros(size(smib.c_v,1),n_step);

b_pr = zeros(size(Gpss.B));
b_pr(1:size(smib.b_pr,1),:) = smib.b_pr;
c_spd = Gpss.C(1,:);
c_v = Gpss.C(2:end,:);

for ii = 1:n_step-1
    dxa(:,ii) = (Gpss.A + K*Gpss.B*c_spd)*xa(:,ii) + b_pr*u(:,ii);
    xa(:,ii+1) = xa(:,ii) + (1/Fs)*dxa(:,ii);
    ya(:,ii) = c_v*xa(:,ii);
end
xa(:,end) = xa(:,end-1);
ya(:,end) = ya(:,end-1);

plot(ax11{1},ts,ya(2,:));

% bottom subplot, power input stabilizer

Gp = ss(smib.a_mat,smib.b_vr,[smib.c_p;smib.c_v],0);
Gp = series(Gp,[tf([0,1],[1,0])]);
Gpss = series(Hpss,Gp);

b_pr = zeros(size(Gpss.A,1),size(smib.b_pr,2));
b_pr(1:size(smib.b_pr,1),:) = smib.b_pr;
c_p = Gpss.C(1,:);
c_v = Gpss.C(2:end,:);

xb = zeros(size(Gpss.A,1),n_step);
dxb = zeros(size(Gpss.A,1),n_step);
yb = zeros(size(smib.c_v,1),n_step);

for ii = 1:n_step-1
    dxb(:,ii) = (Gpss.A - (K/2/(2*H))*Gpss.B*c_p)*xb(:,ii) + b_pr*u(:,ii);
    xb(:,ii+1) = xb(:,ii) + (1/Fs)*dxb(:,ii);
    yb(:,ii) = c_v*xb(:,ii);
end
xb(:,end) = xb(:,end-1);
yb(:,end) = yb(:,end-1);

plot(ax11{2},ts,yb(2,:));

ylabel(ax11{1},'Voltage dev. (pu)');
ylabel(ax11{2},'Voltage dev. (pu)');
xlabel(ax11{2},'Time (s)');

% exporting data file

Fs = 30;                                      % sample rate
tt = ts(1):1/Fs:ts(end);                      % time vector

ya_dec = interp1(ts,ya.',tt).';               % downsampling
yb_dec = interp1(ts,yb.',tt).';               % downsampling

H11 = {'t','v1','v2'};
M11 = [tt; ya_dec(2,:); yb_dec(2,:)];

fid11 = fopen(fig11_name,'w');
fprintf(fid11,'%s,%s,%s\n',H11{:});
fprintf(fid11,'%6e,%6e,%6e\n',M11);
fclose(fid11);

%% fig 13 - delta P/omega frequency response

clear all; close all; clc;
H = 3.558;  % inertia constant

w = 2*pi*linspace(0,10,512);
H_F = tf([0.4,1],conv(conv(conv([0.1,1],[0.1,1]),[0.1,1]),[0.1,1]));
H_FP = (H_F - 1); % *tf([0,1],[2*H,0]);

[magH_F,phaseH_F,wH_F] = bode(H_F,w);
[magH_FP,phaseH_FP,wH_FP] = bode(H_FP,w);

fig13_name = './csv/ch8_fig13.csv';

fig13 = figure;
ax13{1} = subplot(2,1,1,'parent',fig13);
ax13{2} = subplot(2,1,2,'parent',fig13);
hold(ax13{1},'on');
hold(ax13{2},'on');

plot(ax13{1},wH_F/2/pi,squeeze(magH_F));
plot(ax13{1},wH_FP/2/pi,squeeze(magH_FP));
axis(ax13{1},[0,10,0,2]);

plot(ax13{2},wH_F/2/pi,wrapTo180(squeeze(phaseH_F)));
plot(ax13{2},wH_FP/2/pi,wrapTo180(squeeze(phaseH_FP)));
axis(ax13{2},[0,10,-200,200]);

ylabel(ax13{1},'Gain');
ylabel(ax13{2},'Phase (deg)');
xlabel(ax13{2},'Frequency (Hz)');

% exporting data file
H13 = {'f1','g1','gdb1','ph1','f2','g2','gdb2','ph2'};
M13 = [(wH_F/2/pi).'; squeeze(magH_F).'; (20*log10((squeeze(magH_F)))).'; wrapTo180(squeeze(phaseH_F)).';
       (wH_FP/2/pi).'; squeeze(magH_FP).'; (20*log10((squeeze(magH_FP)))).'; wrapTo180(squeeze(phaseH_FP)).'];

fid13 = fopen(fig13_name,'w');
fprintf(fid13,'%s,%s,%s,%s,%s,%s,%s,%s\n',H13{:});
fprintf(fid13,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M13);
fclose(fid13);

%% fig 14 - governor reference ramp

clear all; close all; clc;
load('../mat/datalaag_smib.mat');

a_mat = smib.a_mat;
b_vr = smib.b_vr;
c_spd = smib.c_spd;
c_p = smib.c_p;

fig14_name = './csv/ch8_fig14.csv';

fig14 = figure;
ax14{1} = subplot(2,1,1,'parent',fig14);
ax14{2} = subplot(2,1,2,'parent',fig14);
hold(ax14{1},'on');
hold(ax14{2},'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

Hpss = tf([Tw,0],[Tw,1])*tf([Tn1,1],[Td1,1]);
Gspd = ss(a_mat,b_vr,c_spd,0);
Gpss = series(Hpss,Gspd);
G2out = ss(a_mat,b_vr,[c_spd;c_p],[0;0]);
G2out = series(Hpss,G2out);

b_pr = zeros(size(Gpss.A,1),size(smib.b_pr,2));
b_pr(1:size(smib.b_pr,1),:) = smib.b_pr;
c_v = zeros(size(smib.c_v,1),size(Gpss.C,2));
c_v(:,1:size(smib.c_v,2)) = smib.c_v;

H = 3.558;                                    % inertia constant
K = 10;                                       % control gain
Fs = 240;                                     % sampling frequency
ts = 0:1/Fs:10;
n_step = length(ts);

u = ts;                                       % 1 pu/s ramp
u(u > 1) = 1;
u = u*1.0;
xa = zeros(size(Gpss.A,1),n_step);
dxa = zeros(size(Gpss.A,1),n_step);
ya = zeros(size(smib.c_v,1),n_step);

for ii = 1:n_step-1
    dxa(:,ii) = (Gpss.A + K*Gpss.B*Gpss.C)*xa(:,ii) + b_pr*u(:,ii);
    xa(:,ii+1) = xa(:,ii) + (1/Fs)*dxa(:,ii);
    ya(:,ii) = c_v*xa(:,ii);
end
xa(:,end) = xa(:,end-1);
ya(:,end) = ya(:,end-1);

plot(ax14{1},ts,ya(2,:));

H_F = tf([0.4,1],conv(conv(conv([0.1,1],[0.1,1]),[0.1,1]),[0.1,1]));
% H_FP = (H_F-1)*tf([0,1],[2*H,0]);

Fw = ss([tf([0,1],[0,1])]);                   % pass-thru
Fw.InputName = 'dw';
Fw.OutputName = 'dwpt';
%
Fp = ss([tf([0,1],[2*H,0])]);
Fp.InputName = 'dP';
Fp.OutputName = 'dPI';
%
F = ss([H_F]);
F.InputName = 'u';
F.OutputName = 'y';
%
Sum1 = sumblk('u = dwpt+dPI');
Sum2 = sumblk('dweq = y-dPI');
%
T_dpw = connect(Fw,Fp,Sum1,F,Sum2,{'dw','dP'},'dweq');

b_pr = zeros(size(G2out.A,1),size(smib.b_pr,2));
b_pr(1:size(smib.b_pr,1),:) = smib.b_pr;
c_v = zeros(size(smib.c_v,1),size(G2out.C,2));
c_v(:,1:size(smib.c_v,2)) = smib.c_v;

xb = zeros(size(G2out.A,1),n_step);
dxb = zeros(size(G2out.A,1),n_step);
yb = zeros(size(smib.c_v,1),n_step);
%
xb_dpw = zeros(size(T_dpw.A,1),n_step);
dxb_dpw = zeros(size(T_dpw.A,1),n_step);

for ii = 1:n_step-1
    dxb(:,ii) = G2out.A*xb(:,ii) + K*G2out.B*(T_dpw.C*xb_dpw(:,ii)) + b_pr*u(:,ii);
    dxb_dpw(:,ii) = T_dpw.A*xb_dpw(:,ii) + T_dpw.B*[G2out.C(1,:)*xb(:,ii);G2out.C(2,:)*xb(:,ii)];
    %
    yb(:,ii) = c_v*xb(:,ii);
    %
    xb(:,ii+1) = xb(:,ii) + (1/Fs)*dxb(:,ii);
    xb_dpw(:,ii+1) = xb_dpw(:,ii) + (1/Fs)*dxb_dpw(:,ii);
end
xb(:,end) = xb(:,end-1);
yb(:,end) = yb(:,end-1);

plot(ax14{2},ts,yb(2,:));

ylabel(ax14{1},'Voltage dev. (pu)');
ylabel(ax14{2},'Voltage dev. (pu)');
xlabel(ax14{2},'Time (s)');

% exporting data file

Fs = 30;                                      % sample rate
tt = ts(1):1/Fs:ts(end);                      % time vector

ya_dec = interp1(ts,ya.',tt).';               % downsampling
yb_dec = interp1(ts,yb.',tt).';               % downsampling

H14 = {'t','v1','v2'};
M14 = [tt; ya_dec(2,:); yb_dec(2,:)];

fid14 = fopen(fig14_name,'w');
fprintf(fid14,'%s,%s,%s\n',H14{:});
fprintf(fid14,'%6e,%6e,%6e\n',M14);
fclose(fid14);

%% fig 15 - voltage reference step response

clear all; close all; clc;
load('../mat/datalaag_smib.mat');

a_mat = smib.a_mat;
b_vr = smib.b_vr;
c_spd = smib.c_spd;
c_p = smib.c_p;

fig15_name = './csv/ch8_fig15.csv';

fig15 = figure;
ax15{1} = subplot(2,1,1,'parent',fig15);
ax15{2} = subplot(2,1,2,'parent',fig15);
hold(ax15{1},'on');
hold(ax15{2},'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

Hpss = tf([Tw,0],[Tw,1])*tf([Tn1,1],[Td1,1]);
Gspd = ss(a_mat,b_vr,c_spd,0);
Gpss = series(Hpss,Gspd);
G2out = ss(a_mat,b_vr,[c_spd;c_p],[0;0]);
G2out = series(Hpss,G2out);

b_pr = zeros(size(Gpss.A,1),size(smib.b_pr,2));
b_pr(1:size(smib.b_pr,1),:) = smib.b_pr;
c_spd = zeros(size(smib.c_spd,1),size(Gpss.C,2));
c_spd(:,1:size(smib.c_spd,2)) = smib.c_spd;
c_p = zeros(size(smib.c_p,1),size(Gpss.C,2));
c_p(:,1:size(smib.c_p,2)) = smib.c_p;

H = 3.558;                                    % inertia constant
K = 10;                                       % control gain
Fs = 240;                                     % sampling frequency
ts = 0:1/Fs:10;
n_step = length(ts);

u = 0.05*ones(size(ts));                      % 0.05 pu step
xa = zeros(size(Gpss.A,1),n_step);
dxa = zeros(size(Gpss.A,1),n_step);
ya = zeros(size(smib.c_spd,1),n_step);
za = zeros(size(smib.c_p,1),n_step);

for ii = 1:n_step-1
    dxa(:,ii) = (Gpss.A + K*Gpss.B*Gpss.C)*xa(:,ii) + Gpss.B*u(:,ii);
    xa(:,ii+1) = xa(:,ii) + (1/Fs)*dxa(:,ii);
    ya(:,ii) = c_spd*xa(:,ii);
    za(:,ii) = c_p*xa(:,ii);
end
xa(:,end) = xa(:,end-1);
ya(:,end) = ya(:,end-1);
za(:,end) = za(:,end-1);

plot(ax15{1},ts,ya);

H_F = tf([0.4,1],conv(conv(conv([0.1,1],[0.1,1]),[0.1,1]),[0.1,1]));
H_FP = (H_F-1)*tf([0,1],[2*H,0]);

Fw = ss([tf([0,1],[0,1])]);                   % pass-thru
Fw.InputName = 'dw';
Fw.OutputName = 'dwpt';
%
Fp = ss([tf([0,1],[2*H,0])]);
Fp.InputName = 'dP';
Fp.OutputName = 'dPI';
%
F = ss([H_F]);
F.InputName = 'u';
F.OutputName = 'y';
%
Sum1 = sumblk('u = dwpt+dPI');
Sum2 = sumblk('dweq = y-dPI');
%
T_dpw = connect(Fw,Fp,Sum1,F,Sum2,{'dw','dP'},'dweq');
Gpss_dpw = series(G2out,T_dpw,[1,2],[1,2]);

b_pr = zeros(size(G2out.A,1),size(smib.b_pr,2));
b_pr(1:size(smib.b_pr,1),:) = smib.b_pr;
c_spd = zeros(size(smib.c_spd,1),size(G2out.C,2));
c_spd(:,1:size(smib.c_spd,2)) = smib.c_spd;
c_p = zeros(size(smib.c_p,1),size(G2out.C,2));
c_p(:,1:size(smib.c_p,2)) = smib.c_p;

xb = zeros(size(G2out.A,1),n_step);
dxb = zeros(size(G2out.A,1),n_step);
yb = zeros(size(smib.c_spd,1),n_step);
%
xb_dpw = zeros(size(T_dpw.A,1),n_step);
dxb_dpw = zeros(size(T_dpw.A,1),n_step);
yb_dpw = zeros(size(smib.c_spd,1),n_step);

for ii = 1:n_step-1
    dxb(:,ii) = G2out.A*xb(:,ii) + K*G2out.B*(T_dpw.C*xb_dpw(:,ii)) + G2out.B*u(:,ii);
    dxb_dpw(:,ii) = T_dpw.A*xb_dpw(:,ii) + T_dpw.B*[c_spd*xb(:,ii);c_p*xb(:,ii)];
    %
    yb(:,ii) = c_spd*xb(:,ii);
    yb_dpw(:,ii) = T_dpw.C*xb_dpw(:,ii);
    %
    xb(:,ii+1) = xb(:,ii) + (1/Fs)*dxb(:,ii);
    xb_dpw(:,ii+1) = xb_dpw(:,ii) + (1/Fs)*dxb_dpw(:,ii);
end
xb(:,end) = xb(:,end-1);
yb(:,end) = yb(:,end-1);

plot(ax15{2},ts,yb_dpw);

% exporting data file

Fs = 30;                                      % sample rate
tt = ts(1):1/Fs:ts(end);                      % time vector

ya_dec = interp1(ts,ya.',tt).';               % downsampling
yb_dec = interp1(ts,yb_dpw.',tt).';           % downsampling

H15 = {'t','v1','v2'};
M15 = [tt; ya_dec.'; yb_dec.'];

fid15 = fopen(fig15_name,'w');
fprintf(fid15,'%s,%s,%s\n',H15{:});
fprintf(fid15,'%6e,%6e,%6e\n',M15);
fclose(fid15);

%% fig 18 - Ideal and power system stabilizer phase

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

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

%% figs 19 - aggregate modes root locus (stabilizer 1)

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(1:8,1:8);
c_spd = c_spd(1,1:8);
b_vr = b_vr(1:8,1);

n = size(a_mat,1);

fig19_name = './csv/ch8_fig19.csv';

fig19 = figure;
ax19 = subplot(1,1,1,'parent',fig19);
hold(ax19,'on');
grid(ax19,'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

exc_st = find(b_vr > 10);

% lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td1];
a_tmp1(exc_st,end) = b_vr(exc_st);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*b_vr(exc_st);
a_casc(n+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2]) = [(Tn1/Td1)*b_vr(exc_st); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

% K = 0, 6, 10 (+, square, circle)
plot(ax19,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax19,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax19,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax19,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax19,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax19,[-10,1.0,0,20]);

ylabel(ax19,'Imaginary (rad/s)');
xlabel(ax19,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H19 = {'k','mag','ang','re','im'};
M19 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid19 = fopen(fig19_name,'w');
fprintf(fid19,'%s,%s,%s,%s,%s\n',H19{:});
fprintf(fid19,'%6e,%6e,%6e,%6e,%6e\n',M19);
fclose(fid19);

%% figs 20 - intra-plant modes root locus (stabilizer 1)

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(9:16,9:16);
c_spd = c_spd(2,9:16);
b_vr = b_vr(9:16,2);

n = size(a_mat,1);

fig20_name = './csv/ch8_fig20.csv';

fig20 = figure;
ax20 = subplot(1,1,1,'parent',fig20);
hold(ax20,'on');
grid(ax20,'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

exc_st = find(b_vr > 10);

% lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td1];
a_tmp1(exc_st,end) = b_vr(exc_st);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*b_vr(exc_st);
a_casc(n+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2]) = [(Tn1/Td1)*b_vr(exc_st); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax20,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax20,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax20,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax20,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax20,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax20,[-10,1.0,0,20]);

ylabel(ax20,'Imaginary (rad/s)');
xlabel(ax20,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H20 = {'k','mag','ang','re','im'};
M20 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid20 = fopen(fig20_name,'w');
fprintf(fid20,'%s,%s,%s,%s,%s\n',H20{:});
fprintf(fid20,'%6e,%6e,%6e,%6e,%6e\n',M20);
fclose(fid20);

%% figs 21 - aggregate modes root locus (stabilizer 2)

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(1:8,1:8);
c_spd = c_spd(1,1:8);
b_vr = b_vr(1:8,1);

n = size(a_mat,1);

fig21_name = './csv/ch8_fig21.csv';

fig21 = figure;
ax21 = subplot(1,1,1,'parent',fig21);
hold(ax21,'on');
grid(ax21,'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.4;
Td1 = 0.3;

exc_st = find(b_vr > 10);

% lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td1];
a_tmp1(exc_st,end) = b_vr(exc_st);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*b_vr(exc_st);
a_casc(n+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2]) = [(Tn1/Td1)*b_vr(exc_st); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax21,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax21,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax21,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax21,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax21,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax21,[-10,1.0,0,20]);

ylabel(ax21,'Imaginary (rad/s)');
xlabel(ax21,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H21 = {'k','mag','ang','re','im'};
M21 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid21 = fopen(fig21_name,'w');
fprintf(fid21,'%s,%s,%s,%s,%s\n',H21{:});
fprintf(fid21,'%6e,%6e,%6e,%6e,%6e\n',M21);
fclose(fid21);

%% figs 22 - intra-plant modes root locus (stabilizer 2)

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(9:16,9:16);
c_spd = c_spd(2,9:16);
b_vr = b_vr(9:16,2);

n = size(a_mat,1);

fig22_name = './csv/ch8_fig22.csv';

fig22 = figure;
ax22 = subplot(1,1,1,'parent',fig22);
hold(ax22,'on');
grid(ax22,'on');

% compensation parameters
Tw = 1.41;
Tn1 = 0.4;
Td1 = 0.3;

exc_st = find(b_vr > 10);

% lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td1];
a_tmp1(exc_st,end) = b_vr(exc_st);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*b_vr(exc_st);
a_casc(n+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2]) = [(Tn1/Td1)*b_vr(exc_st); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax22,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax22,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax22,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax22,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax22,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax22,[-5,1.0,0,20]);

ylabel(ax22,'Imaginary (rad/s)');
xlabel(ax22,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H22 = {'k','mag','ang','re','im'};
M22 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid22 = fopen(fig22_name,'w');
fprintf(fid22,'%s,%s,%s,%s,%s\n',H22{:});
fprintf(fid22,'%6e,%6e,%6e,%6e,%6e\n',M22);
fclose(fid22);

%% figs 23 - aggregate modes root locus (stabilizer 3)

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(1:8,1:8);
c_spd = c_spd(1,1:8);
b_vr = b_vr(1:8,1);

n = size(a_mat,1);

fig23_name = './csv/ch8_fig23.csv';

fig23 = figure;
ax23 = subplot(1,1,1,'parent',fig23);
hold(ax23,'on');
grid(ax23,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.05;
Td1 = 0.01;
Tn2 = 0.05;
Td2 = 0.01;

exc_st = find(b_vr > 10);

% second lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td2];
a_tmp1(exc_st,end) = b_vr(exc_st);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*b_vr(exc_st);
a_tmp2(n+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st);
a_casc(n+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2;n+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st), ...
                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax23,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax23,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax23,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax23,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax23,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax23,[-10,1.0,0,20]);

ylabel(ax23,'Imaginary (rad/s)');
xlabel(ax23,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H23 = {'k','mag','ang','re','im'};
M23 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid23 = fopen(fig23_name,'w');
fprintf(fid23,'%s,%s,%s,%s,%s\n',H23{:});
fprintf(fid23,'%6e,%6e,%6e,%6e,%6e\n',M23);
fclose(fid23);

%% figs 24 - intra-plant modes root locus (stabilizer 3)

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(9:16,9:16);
c_spd = c_spd(2,9:16);
b_vr = b_vr(9:16,2);

n = size(a_mat,1);

fig24_name = './csv/ch8_fig24.csv';

fig24 = figure;
ax24 = subplot(1,1,1,'parent',fig24);
hold(ax24,'on');
grid(ax24,'on');

% compensation parameters
Tw = 10;
Tn1 = 0.05;
Td1 = 0.01;
Tn2 = 0.05;
Td2 = 0.01;

exc_st = find(b_vr > 10);

% second lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td2];
a_tmp1(exc_st,end) = b_vr(exc_st);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*b_vr(exc_st);
a_tmp2(n+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st);
a_casc(n+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2;n+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st), ...
                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax24,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax24,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax24,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax24,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax24,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax24,[-5,1.0,0,20]);

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

%% figs 25 - aggregate modes root locus (stabilizer 4)

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(1:8,1:8);
c_spd = c_spd(1,1:8);
b_vr = b_vr(1:8,1);

n = size(a_mat,1);

fig25_name = './csv/ch8_fig25.csv';

fig25 = figure;
ax25 = subplot(1,1,1,'parent',fig25);
hold(ax25,'on');
grid(ax25,'on');

% compensation parameters
Tw = 5;
Tn1 = 0.10;
Td1 = 0.01;
Tn2 = 0.10;
Td2 = 0.01;

exc_st = find(b_vr > 10);

% second lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td2];
a_tmp1(exc_st,end) = b_vr(exc_st);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*b_vr(exc_st);
a_tmp2(n+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st);
a_casc(n+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2;n+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st), ...
                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax25,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax25,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax25,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax25,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax25,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax25,[-10,1.0,0,20]);

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

%% figs 26 - intra-plant modes root locus (stabilizer 4)

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat = a_mat(9:16,9:16);
c_spd = c_spd(2,9:16);
b_vr = b_vr(9:16,2);

n = size(a_mat,1);

fig26_name = './csv/ch8_fig26.csv';

fig26 = figure;
ax26 = subplot(1,1,1,'parent',fig26);
hold(ax26,'on');
grid(ax26,'on');

% compensation parameters
Tw = 5;
Tn1 = 0.10;
Td1 = 0.01;
Tn2 = 0.10;
Td2 = 0.01;

exc_st = find(b_vr > 10);

% second lead-lag stage
a_tmp1 = [a_mat, zeros(size(a_mat,1),1); zeros(1,size(c_spd,2)), -1/Td2];
a_tmp1(exc_st,end) = b_vr(exc_st);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st,end) = (Tn2/Td2)*b_vr(exc_st);
a_tmp2(n+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st);
a_casc(n+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st;n+1;n+2;n+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr(exc_st), ...
                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, (1-Tn1/Td1)/Td1,-1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd,2)) = c_spd;

k = 0:0.1:10;
eig_track = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track(:,ii) = eig_tmp;
end

plot(ax26,[0,-25],[0,25*tan(acos(0.05))],'k');
plot(ax26,real(eig_track(:,1:end-1)),imag(eig_track(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax26,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax26,real(eig_track(:,61)),imag(eig_track(:,61)),'rs','markerSize',6.5);
plot(ax26,real(eig_track(:,end)),imag(eig_track(:,end)),'ro','markerSize',6.5);
axis(ax26,[-10,1.0,0,20]);

ylabel(ax26,'Imaginary (rad/s)');
xlabel(ax26,'Real');

% exporting data file
rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H26 = {'k','mag','ang','re','im'};
M26 = [1:1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec); real(rl_vec); imag(rl_vec)];

fid26 = fopen(fig26_name,'w');
fprintf(fid26,'%s,%s,%s,%s,%s\n',H26{:});
fprintf(fid26,'%6e,%6e,%6e,%6e,%6e\n',M26);
fclose(fid26);

%% figs 27 - speed feedback

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

fig271_name = './csv/ch8_fig27_1.csv';
fig272_name = './csv/ch8_fig27_2.csv';
fig273_name = './csv/ch8_fig27_3.csv';
fig274_name = './csv/ch8_fig27_4.csv';

fig27 = figure;
ax271 = subplot(2,2,1,'parent',fig27);
ax272 = subplot(2,2,2,'parent',fig27);
ax273 = subplot(2,2,3,'parent',fig27);
ax274 = subplot(2,2,4,'parent',fig27);
%
hold(ax271,'on');
hold(ax272,'on');
hold(ax273,'on');
hold(ax274,'on');
%
grid(ax271,'on');
grid(ax272,'on');
grid(ax273,'on');
grid(ax274,'on');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_spd = c_spd*P;
b_vr = P\b_vr;

a_mat_agg = a_mat(1:8,1:8);
c_spd_agg = c_spd(1,1:8);
b_vr_agg = b_vr(1:8,1);

a_mat_ip = a_mat(9:16,9:16);
c_spd_ip = c_spd(2,9:16);
b_vr_ip = b_vr(9:16,2);

n_agg = size(a_mat_agg,1);
exc_st_agg = find(b_vr_agg > 10);

n_ip = size(a_mat_ip,1);
exc_st_ip = find(b_vr_ip > 10);

% subplot 1 aggregate

% stabilizer 1 parameters
Tw = 1.41;
Tf = 0.01;
Tn1 = 0.154;
Td1 = 0.033;

% lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_spd_agg,2)), -1/Td1];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2]) = [(Tn1/Td1)*b_vr_agg(exc_st_agg); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_agg,2)) = c_spd_agg;

k = 0:0.1:10;
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax271,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax271,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax271,[-60,2,0,20]);

% subplot 1 intra-plant

% lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_spd_ip,2)), -1/Td1];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2]) = [(Tn1/Td1)*b_vr_ip(exc_st_ip); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_ip,2)) = c_spd_ip;

k = 0:0.1:10;
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax271,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax271,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax271,[-60,2,0,20]);

ylabel(ax271,'Imaginary (rad/s)');
xlabel(ax271,'Real');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H271 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M271 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid271 = fopen(fig271_name,'w');
fprintf(fid271,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H271{:});
fprintf(fid271,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M271);
fclose(fid271);

% subplot 2 aggregate

% stabilizer 2 parameters
Tw = 1.41;
Tf = 0.01;
Tn1 = 0.4;
Td1 = 0.3;

% lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_spd_agg,2)), -1/Td1];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2]) = [(Tn1/Td1)*b_vr_agg(exc_st_agg); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_agg,2)) = c_spd_agg;

k = 0:0.1:10;
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax272,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax272,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax272,[-60,20,0,50]);

% subplot 2 intra-plant

% lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_spd_ip,2)), -1/Td1];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% washout
a_casc = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_casc(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2]) = [(Tn1/Td1)*b_vr_ip(exc_st_ip); (1-Tn1/Td1)/Td1; -1/Tw];
c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_ip,2)) = c_spd_ip;

k = 0:0.1:10;
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax272,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax272,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax272,[-60,2,0,20]);

ylabel(ax272,'Imaginary (rad/s)');
xlabel(ax272,'Real');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H272 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M272 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid272 = fopen(fig272_name,'w');
fprintf(fid272,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H272{:});
fprintf(fid272,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M272);
fclose(fid272);

% subplot 3 aggregate

% stabilizer 3 parameters
Tw = 10;
Tf = 0.01;
Tn1 = 0.05;
Td1 = 0.01;
Tn2 = 0.05;
Td2 = 0.01;

% second lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_spd_agg,2)), -1/Td2];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_agg,end) = (Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_agg+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg), ...
                                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                                (1-Tn1/Td1)/Td1, -1/Tw];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_agg,2)) = c_spd_agg;

k = 0:0.1:10;
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax273,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax273,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax273,[-60,1,0,20]);

% subplot 3 intra-plant

% second lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_spd_ip,2)), -1/Td2];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_ip,end) = (Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_ip+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip), ...
                                            (Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                            (1-Tn1/Td1)/Td1, -1/Tw];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_ip,2)) = c_spd_ip;

k = 0:0.1:10;
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax273,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax273,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax273,[-60,1,0,20]);

ylabel(ax273,'Imaginary (rad/s)');
xlabel(ax273,'Real');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H273 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M273 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid273 = fopen(fig273_name,'w');
fprintf(fid273,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H273{:});
fprintf(fid273,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M273);
fclose(fid273);

% subplot 4 aggregate

% stabilizer 4 parameters
Tw = 5;
Tf = 0.01;
Tn1 = 0.10;
Td1 = 0.01;
Tn2 = 0.10;
Td2 = 0.01;
%
% second lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_spd_agg,2)), -1/Td2];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_agg,end) = (Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_agg+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg), ...
                                                (Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                                (1-Tn1/Td1)/Td1, -1/Tw];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_agg,2)) = c_spd_agg;

k = 0:0.1:10;
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax274,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax274,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax274,[-60,1,0,20]);

% subplot 4 intra-plant

% second lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_spd_ip,2)), -1/Td2];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_ip,end) = (Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_casc(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_ip+2,end) = (1 - Tn1/Td1)/Td1;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3]) = [(Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip), ...
                                            (Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
                                            (1-Tn1/Td1)/Td1, -1/Tw];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_spd_ip,2)) = c_spd_ip;

k = 0:0.1:10;
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax274,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax274,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax274,[-60,1,0,20]);

ylabel(ax274,'Imaginary (rad/s)');
xlabel(ax274,'Real');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H274 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M274 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid274 = fopen(fig274_name,'w');
fprintf(fid274,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H274{:});
fprintf(fid274,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M274);
fclose(fid274);

%% figs 28 - frequency feedback

clear all; close all; clc;
load('../mat/datalam_stsp.mat');

fig281_name = './csv/ch8_fig28_1.csv';
fig282_name = './csv/ch8_fig28_2.csv';
fig283_name = './csv/ch8_fig28_3.csv';
fig284_name = './csv/ch8_fig28_4.csv';

fig28 = figure;
ax281 = subplot(2,2,1,'parent',fig28);
ax282 = subplot(2,2,2,'parent',fig28);
ax283 = subplot(2,2,3,'parent',fig28);
ax284 = subplot(2,2,4,'parent',fig28);
%
hold(ax281,'on');
hold(ax282,'on');
hold(ax283,'on');
hold(ax284,'on');
%
grid(ax281,'on');
grid(ax282,'on');
grid(ax283,'on');
grid(ax284,'on');

P = eye(32);
P(9:16,1:8) = eye(8);
P(17:24,1:8) = eye(8);
P(25:32,1:8) = eye(8);

a_mat = P\(a_mat*P);
c_ang = c_ang*P;
b_vr = P\b_vr;

a_mat_agg = a_mat(1:8,1:8);
c_ang_agg = c_ang(6,1:8);
b_vr_agg = b_vr(1:8,1);

a_mat_ip = a_mat(9:16,9:16);
c_ang_ip = c_ang(6,9:16);
b_vr_ip = b_vr(9:16,2);

n_agg = size(a_mat_agg,1);
exc_st_agg = find(b_vr_agg > 10);

n_ip = size(a_mat_ip,1);
exc_st_ip = find(b_vr_ip > 10);

% subplot 1 aggregate

% stabilizer 1 parameters
Tw = 1.41;
Tf = 0.01;
Tn1 = 0.154;
Td1 = 0.033;

% first lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_ang_agg,2)), -1/Td1];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% washout
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_tmp2(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tf];
a_casc(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_agg+2,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3]) = ...
        [(1/Tf)*(Tn1/Td1)*b_vr_agg(exc_st_agg), ...
         (1/Tf)*(1 - Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_agg,2)) = c_ang_agg;

k = (0:0.1:10)/(2*pi*60);
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax281,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax281,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax281,[-60,20,0,50]);

% subplot 1 intra-plant

% first lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_ang_ip,2)), -1/Td1];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% washout
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_tmp2(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tf];
a_casc(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_ip+2,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3]) = ...
        [(1/Tf)*(Tn1/Td1)*b_vr_ip(exc_st_ip), ...
         (1/Tf)*(1 - Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_ip,2)) = c_ang_ip;

k = (0:0.1:10)/(2*pi*60);
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax281,real(eig_track_ip(:,1:2)),imag(eig_track_ip(:,1:2)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax281,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax281,[-60,20,0,50]);

ylabel(ax281,'Imaginary (rad/s)');
xlabel(ax281,'Real');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H281 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M281 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid281 = fopen(fig281_name,'w');
fprintf(fid281,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H281{:});
fprintf(fid281,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M281);
fclose(fid281);

% subplot 2 aggregate

% stabilizer 2 parameters
Tw = 1.41;
Tf = 0.01;
Tn1 = 0.4;
Td1 = 0.3;

% first lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_ang_agg,2)), -1/Td1];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% washout
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_tmp2(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tf];
a_casc(exc_st_agg,end) = (Tn1/Td1)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_agg+2,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3]) = ...
        [(1/Tf)*(Tn1/Td1)*b_vr_agg(exc_st_agg), ...
         (1/Tf)*(1 - Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_agg,2)) = c_ang_agg;

k = (0:0.1:10)/(2*pi*60);
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax282,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax282,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax282,[-60,20,0,50]);

% subplot 2 intra-plant

% first lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_ang_ip,2)), -1/Td1];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% washout
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Tw];
a_tmp2(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tf];
a_casc(exc_st_ip,end) = (Tn1/Td1)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_ip+2,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3]) = ...
        [(1/Tf)*(Tn1/Td1)*b_vr_ip(exc_st_ip), ...
         (1/Tf)*(1 - Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_ip,2)) = c_ang_ip;

k = (0:0.1:10)/(2*pi*60);
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax282,real(eig_track_ip(:,1:2)),imag(eig_track_ip(:,1:2)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax282,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax282,[-60,20,0,50]);

ylabel(ax282,'Imaginary (rad/s)');
xlabel(ax282,'Real');

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H282 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M282 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid282 = fopen(fig282_name,'w');
fprintf(fid282,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H282{:});
fprintf(fid282,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M282);
fclose(fid282);

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H282 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M282 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid282 = fopen(fig282_name,'w');
fprintf(fid282,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H282{:});
fprintf(fid282,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M282);
fclose(fid282);

% subplot 3 aggregate

% stabilizer 3 parameters
Tw = 10;
Tf = 0.01;
Tn1 = 0.05;
Td1 = 0.01;
Tn2 = 0.05;
Td2 = 0.01;

% second lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_ang_agg,2)), -1/Td2];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_agg,end) = (Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_tmp3 = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_tmp3(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp3(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_tmp3(n_agg+2,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp3, zeros(size(a_tmp3,1),1); zeros(1,size(a_tmp3,2)), -1/Tf];
a_casc(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_agg+2,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_agg+3,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3;n_agg+4]) = ...
        [(1/Tf)*(Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg), ...
         (1/Tf)*(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
         (1/Tf)*(1-Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_agg,2)) = c_ang_agg;

k = (0:0.1:10)/(2*pi*60);
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax283,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax283,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax283,[-60,20,0,50]);

% subplot 3 intra-plant

% second lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_ang_ip,2)), -1/Td2];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_ip,end) = (Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_tmp3 = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_tmp3(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp3(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_tmp3(n_ip+2,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp3, zeros(size(a_tmp3,1),1); zeros(1,size(a_tmp3,2)), -1/Tf];
a_casc(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_ip+2,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_ip+3,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3;n_ip+4]) = ...
        [(1/Tf)*(Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip), ...
         (1/Tf)*(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
         (1/Tf)*(1-Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_ip,2)) = c_ang_ip;

k = (0:0.1:10)/(2*pi*60);
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax283,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax283,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax283,[-60,20,0,50]);

ylabel(ax283,'Imaginary (rad/s)');
xlabel(ax283,'Real');

% filtering out neglected locus
mask = (real(eig_track_ip) < -20) & (abs(imag(eig_track_ip)) > 20);
mask = mask | (real(eig_track_ip) < -60);
eig_track_ip(mask) = -90;

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H283 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M283 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid283 = fopen(fig283_name,'w');
fprintf(fid283,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H283{:});
fprintf(fid283,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M283);
fclose(fid283);

% subplot 4 aggregate

% stabilizer 4 parameters
Tw = 5;
Tf = 0.01;
Tn1 = 0.10;
Td1 = 0.01;
Tn2 = 0.10;
Td2 = 0.01;

% second lead-lag stage
a_tmp1 = [a_mat_agg, zeros(size(a_mat_agg,1),1); zeros(1,size(c_ang_agg,2)), -1/Td2];
a_tmp1(exc_st_agg,end) = b_vr_agg(exc_st_agg);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_agg,end) = (Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp2(n_agg+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_tmp3 = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_tmp3(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_tmp3(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_tmp3(n_agg+2,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp3, zeros(size(a_tmp3,1),1); zeros(1,size(a_tmp3,2)), -1/Tf];
a_casc(exc_st_agg,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg);
a_casc(n_agg+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_agg+2,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_agg+3,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_agg;n_agg+1;n_agg+2;n_agg+3;n_agg+4]) = ...
        [(1/Tf)*(Tn1/Td1)*(Tn2/Td2)*b_vr_agg(exc_st_agg), ...
         (1/Tf)*(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
         (1/Tf)*(1-Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_agg,2)) = c_ang_agg;

k = (0:0.1:10)/(2*pi*60);
eig_track_agg = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_agg(:,ii) = eig_tmp;
end

plot(ax284,real(eig_track_agg(:,1:end-1)),imag(eig_track_agg(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax284,real(eig_track_agg(:,1)),imag(eig_track_agg(:,1)),'r+','lineWidth',0.75);
axis(ax284,[-60,20,0,50]);

% subplot 4 intra-plant

% second lead-lag stage
a_tmp1 = [a_mat_ip, zeros(size(a_mat_ip,1),1); zeros(1,size(c_ang_ip,2)), -1/Td2];
a_tmp1(exc_st_ip,end) = b_vr_ip(exc_st_ip);

% first lead-lag stage
a_tmp2 = [a_tmp1, zeros(size(a_tmp1,1),1); zeros(1,size(a_tmp1,2)), -1/Td1];
a_tmp2(exc_st_ip,end) = (Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp2(n_ip+1,end) = (1 - Tn2/Td2)/Td2;

% washout
a_tmp3 = [a_tmp2, zeros(size(a_tmp2,1),1); zeros(1,size(a_tmp2,2)), -1/Tw];
a_tmp3(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_tmp3(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_tmp3(n_ip+2,end) = (1 - Tn1/Td1)/Td1;

% rate filter for frequency estimation
a_casc = [a_tmp3, zeros(size(a_tmp3,1),1); zeros(1,size(a_tmp3,2)), -1/Tf];
a_casc(exc_st_ip,end) = (Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip);
a_casc(n_ip+1,end) = (Tn1/Td1)*(1 - Tn2/Td2)/Td2;
a_casc(n_ip+2,end) = (1 - Tn1/Td1)/Td1;
a_casc(n_ip+3,end) = -1/Tw;

% input and output matrices
b_casc = zeros(size(a_casc,1),1);
b_casc([exc_st_ip;n_ip+1;n_ip+2;n_ip+3;n_ip+4]) = ...
        [(1/Tf)*(Tn1/Td1)*(Tn2/Td2)*b_vr_ip(exc_st_ip), ...
         (1/Tf)*(Tn1/Td1)*(1 - Tn2/Td2)/Td2, ...
         (1/Tf)*(1-Tn1/Td1)/Td1, ...
         (1/Tf)*(-1/Tw), ...
         (1/Tf)*(-1/Tf)];

c_casc = zeros(1,size(a_casc,1));
c_casc(1:size(c_ang_ip,2)) = c_ang_ip;

k = (0:0.1:10)/(2*pi*60);
eig_track_ip = zeros(size(a_casc,1),length(k));
for ii = 1:length(k)
    dd = eig(a_casc + k(ii)*b_casc*c_casc);
    eig_tmp = sort(dd,'descend','comparisonMethod','real');
    eig_track_ip(:,ii) = eig_tmp;
end

plot(ax284,real(eig_track_ip(:,1:end-1)),imag(eig_track_ip(:,1:end-1)),'bd','markerFaceColor','b','markerSize',3.5);
plot(ax284,real(eig_track_ip(:,1)),imag(eig_track_ip(:,1)),'r+','lineWidth',0.75);
axis(ax284,[-60,20,0,50]);

ylabel(ax284,'Imaginary (rad/s)');
xlabel(ax284,'Real');

% filtering out neglected locus
mask = (real(eig_track_ip) < -20) & (abs(imag(eig_track_ip)) > 20);
mask = mask | (real(eig_track_ip) < -60);
eig_track_ip(mask) = -90;

% exporting data file
rl_vec_agg = reshape(eig_track_agg,[1,numel(eig_track_agg)]);
rl_vec_ip = reshape(eig_track_ip,[1,numel(eig_track_ip)]);

H284 = {'k1','mag1','ang1','re1','im1','k2','mag2','ang2','re2','im2'};
M284 = [1:1:length(rl_vec_agg); abs(rl_vec_agg); (180/pi)*angle(rl_vec_agg); real(rl_vec_agg); imag(rl_vec_agg); ...
        1:1:length(rl_vec_ip); abs(rl_vec_ip); (180/pi)*angle(rl_vec_ip); real(rl_vec_ip); imag(rl_vec_ip)];

fid284 = fopen(fig284_name,'w');
fprintf(fid284,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H284{:});
fprintf(fid284,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M284);
fclose(fid284);

% eof
