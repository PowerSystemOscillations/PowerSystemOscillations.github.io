% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.6

% emmitranpma1.mat: change in torque, nonlinear simulation
% emmistsp.mat: state-space model for d2aem.m with redistributed inertia

clear all; close all; clc;                    % reset workspace
load('../mat/emmitranpma1.mat');              % nonlinear simulation
load('../mat/emmistsp.mat');                  % state-space model

Fs = 30;                                      % sample rate
ts_step = 1e-4;                               % linear simulation time step
tt = t(1):1/Fs:t(end);                        % time vector with constant step size
ts = t(1):ts_step:t(end);                     % time vector for the linearized sim.

x = zeros(size(a_mat,1),length(ts));          % linearized system state vector
dx = zeros(size(a_mat,1),length(ts));         % linearized state derivatives
u = zeros(size(mac_spd,1),length(ts));        % linearized system input vector
y = zeros(size(c_v,1),length(ts));            % linearized bus voltage vector

for ii = 1:length(ts)
    u(1,ii) = 0.01;                           % change in torque at gen. 1
    u(2,ii) = -0.01;                          % change in torque at gen. 2

    dx(:,ii) = a_mat*x(:,ii) + b_pm*u(:,ii);
    y(:,ii) = c_v*x(:,ii);

    if (ii < length(ts))
        x(:,ii+1) = x(:,ii) + dx(:,ii)*ts_step;
    end
end

%-------------------------------------%
% fig 6

fig6_name = './csv/ch3_fig6.csv';             % data file
spd_idx = find(mac_state(:,2)==2);            % rotor speed state index

fig6 = figure;                                % create figure table
ax61 = subplot(2,1,1,'parent',fig6);
ax62 = subplot(2,1,2,'parent',fig6);
hold(ax61,'on');                              % always on for axis objects
hold(ax62,'on');
plot(ax61, ts, x(spd_idx(1),:));
plot(ax61, ts, x(spd_idx(2),:));
plot(ax62, ts, x(spd_idx(3),:));
plot(ax62, ts, x(spd_idx(4),:));

% axis labels
xlabel(ax62,'Time (s)');
ylabel(ax61,'Speed deviation (pu)');
ylabel(ax62,'Speed deviation (pu)');

v = axis(ax61);
axis(ax61,[v(1),v(2),-2e-4,6e-4]);

% ingraph legend
legend(ax61,{'gen1','gen2'},'location','best');
legend(ax62,{'gen3','gen4'},'location','best');

% exporting data file (both linear and nonlinear simulation data
x_spd_dec = interp1(ts,x(spd_idx,:).',tt).';  % downsampling linear data
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling nonlinear data

H6 = {'t','lc1','lc2','lc3','lc4','c1','c2','c3','c4'};
M6 = [tt; x_spd_dec(1,:); x_spd_dec(2,:); x_spd_dec(3,:); x_spd_dec(4,:); ...
      mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
      mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid6 = fopen(fig6_name,'w');
fprintf(fid6,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H6{:});
fprintf(fid6,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M6);
fclose(fid6);

% eof
