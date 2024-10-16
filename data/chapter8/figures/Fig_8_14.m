% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.14

% datalaag_smib.mat: 550 MVA single-generator infinite bus model, state-space

clear all; close all; clc;
load('../mat/datalaag_smib.mat');

%-------------------------------------%
% fig 14

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

% eof
