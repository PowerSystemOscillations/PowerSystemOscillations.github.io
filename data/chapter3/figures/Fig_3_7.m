% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.7

% emmitranpma1.mat: change in torque, nonlinear simulation
% emmistsp.mat: state-space model for d2aem.m with redistributed inertia

clear all; close all; clc;                    % reset workspace
load('../mat/emmitranpma1.mat');              % nonlinear simulation
load('../mat/emmistsp.mat');                  % state-space model

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
    u(2,ii) = -0.01;                          % change in torque at gen. 2

    dx(:,ii) = a_mat*x(:,ii) + b_pm*u(:,ii);
    y(:,ii) = c_v*x(:,ii);

    if (ii < length(ts))
        x(:,ii+1) = x(:,ii) + dx(:,ii)*ts_step;
    end
end

%-------------------------------------%
% fig 7

fig7_name = './csv/ch3_fig7.csv';             % data file
spd_idx = find(mac_state(:,2)==2);            % rotor speed state index

fig7 = figure;                                % create figure table
ax71 = subplot(2,1,1,'parent',fig7);
ax72 = subplot(2,1,2,'parent',fig7);
hold(ax71,'on');                              % always on for axis objects
hold(ax72,'on');
plot(ax71, t, mac_spd(1,:)-mac_spd(1,1));
plot(ax71, t, mac_spd(2,:)-mac_spd(2,1));
plot(ax72, t, mac_spd(3,:)-mac_spd(3,1));
plot(ax72, t, mac_spd(4,:)-mac_spd(4,1));

% axis labels
xlabel(ax72,'Time (s)');
ylabel(ax71,'Speed deviation (pu)');
ylabel(ax72,'Speed deviation (pu)');

v = axis(ax71);
axis(ax71,[v(1),v(2),-2e-4,6e-4]);

% ingraph legend
legend(ax71,{'gen1','gen2'},'location','best');
legend(ax72,{'gen3','gen4'},'location','best');

% exporting data file (both linear and nonlinear simulation data
x_spd_dec = interp1(ts,x(spd_idx,:).',tt).';  % downsampling linear data
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling nonlinear data

H7 = {'t','lc1','lc2','lc3','lc4','c1','c2','c3','c4'};
M7 = [tt; x_spd_dec(1,:); x_spd_dec(2,:); x_spd_dec(3,:); x_spd_dec(4,:); ...
      mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
      mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid7 = fopen(fig7_name,'w');
fprintf(fid7,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H7{:});
fprintf(fid7,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M7);
fclose(fid7);

% eof
