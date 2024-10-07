% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.16

% sbegtranpr1.mat: turbine/governor reference step, nonlinear simulation
% sbegstsp.mat: state-space model for d2asbeg.m

clear all; close all; clc;                    % reset workspace
load('../mat/sbegtranpr1.mat');               % nonlinear simulation
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
    u(1,ii) = 0.01;                           % change in torque at gen. 1

    dx(:,ii) = a_mat*x(:,ii) + b_pr*u(:,ii);
    y(:,ii) = c_v*x(:,ii);

    if (ii < length(ts))
        x(:,ii+1) = x(:,ii) + dx(:,ii)*ts_step;
    end
end

fig16_name = './csv/ch3_fig16.csv';           % data file
spd_idx = find(mac_state(:,2)==2);            % rotor speed state index

fig16 = figure;                               % create figure table
ax161 = subplot(2,1,1,'parent',fig16);
ax162 = subplot(2,1,2,'parent',fig16);
xlim(ax161,[0 30]);
ylim(ax161,[0.0 2e-4]);
xlim(ax162,[0 30]);
ylim(ax162,[0.0 2e-4]);
hold(ax161,'on');                             % always on for axis object
hold(ax162,'on');
plot(ax161, ts, x(spd_idx(1),:));
plot(ax161, ts, x(spd_idx(2),:));
plot(ax162, ts, x(spd_idx(3),:));
plot(ax162, ts, x(spd_idx(4),:));

% axis labels
xlabel(ax162,'Time (s)');
ylabel(ax161,'Speed change (pu)');
ylabel(ax162,'Speed change (pu)');

% ingraph legend
legend(ax161,{'gen1','gen2'},'location','best');
legend(ax162,{'gen3','gen4'},'location','best');

% exporting data file (both linear and nonlinear simulation data
x_spd_dec = interp1(ts,x(spd_idx,:).',tt).';  % downsampling linear data
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling nonlinear data

H16 = {'t','lc1','lc2','lc3','lc4','c1','c2','c3','c4'};
M16 = [tt; x_spd_dec(1,:); x_spd_dec(2,:); x_spd_dec(3,:); x_spd_dec(4,:); ...
      mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
      mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid16 = fopen(fig16_name,'w');
fprintf(fid16,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H16{:});
fprintf(fid16,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M16);
fclose(fid16);

% eof
