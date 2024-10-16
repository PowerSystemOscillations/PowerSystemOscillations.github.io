% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.11

% datalaag_smib.mat: 550 MVA single-generator infinite bus model, state-space

clear all; close all; clc;
load('../mat/datalaag_smib.mat');

%-------------------------------------%
% fig 11

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

% eof
