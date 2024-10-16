% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.11

% datalaag_smib.mat: 550 MVA single-generator infinite bus model, state-space

clear all; close all; clc;
load('../mat/datalaag_smib.mat');

%-------------------------------------%
% fig 15

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

% eof
