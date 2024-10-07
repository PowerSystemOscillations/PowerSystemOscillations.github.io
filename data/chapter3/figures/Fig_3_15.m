% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.15

% sbegtranvr1.mat: voltage reference step, nonlinear simulation
% sbegstsp.mat: state-space model for d2asbeg.m

clear all; close all; clc;                    % reset workspace
load('../mat/sbegtranvr1.mat');               % nonlinear simulation
load('../mat/sbegstsp.mat');                  % state-space model

Fs = 30;                                      % sample rate
ts_step = 1e-4;                               % linear simulation time step
tt = t(1):1/Fs:t(end);                        % time vector with constant step size
ts = t(1):ts_step:t(end);                     % time vector for the linearized simulation

x = zeros(size(a_mat,1),length(ts));          % linearized system state vector
dx = zeros(size(a_mat,1),length(ts));         % linearized state derivatives
u = zeros(size(mac_spd,1),length(ts));        % linearized system input vector
y = zeros(size(c_v,1),length(ts));            % linearized bus voltage vector

for ii = 1:length(ts)
    u(1,ii) = 0.01;                           % voltage reference step

    dx(:,ii) = a_mat*x(:,ii) + b_vr*u(:,ii);
    y(:,ii) = c_v*x(:,ii);

    if (ii < length(ts))
        x(:,ii+1) = x(:,ii) + dx(:,ii)*ts_step;
    end
end

fig15_name = './csv/ch3_fig15.csv';           % data file
spd_idx = find(mac_state(:,2)==2);            % rotor speed state index

fig15 = figure;                               % create figure table
ax151 = subplot(2,1,1,'parent',fig15);
ax152 = subplot(2,1,2,'parent',fig15);
xlim(ax151,[0 30]);
ylim(ax151,[-4e-4 2e-4]);
xlim(ax152,[0 30]);
ylim(ax152,[-4e-4 4e-4]);
hold(ax151,'on');                             % always on for axis object
hold(ax152,'on');
plot(ax151, ts, x(spd_idx(1),:));
plot(ax151, ts, x(spd_idx(2),:));
plot(ax152, ts, x(spd_idx(3),:));
plot(ax152, ts, x(spd_idx(4),:));

% axis labels
xlabel(ax152,'Time (s)');
ylabel(ax151,'Speed change (pu)');
ylabel(ax152,'Speed change (pu)');
v = axis(ax152);
axis(ax151,[v(1),v(2),v(3),v(4)]);

% ingraph legend
legend(ax151,{'gen1','gen2'},'location','best');
legend(ax152,{'gen3','gen4'},'location','best');

% exporting data file (both linear and nonlinear simulation data
x_spd_dec = interp1(ts,x(spd_idx,:).',tt).';  % downsampling linear data
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling nonlinear data

H15 = {'t','lc1','lc2','lc3','lc4','c1','c2','c3','c4'};
M15 = [tt; x_spd_dec(1,:); x_spd_dec(2,:); x_spd_dec(3,:); x_spd_dec(4,:); ...
      mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
      mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid15 = fopen(fig15_name,'w');
fprintf(fid15,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H15{:});
fprintf(fid15,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M15);
fclose(fid15);

% eof
