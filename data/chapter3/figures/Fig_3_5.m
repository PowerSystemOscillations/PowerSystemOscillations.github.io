% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.5

% emtranpma1.mat: step change in torque, nonlinear simulation
% emstsp.mat: state-space model for d2aem.m

clear all; close all; clc;                    % reset workspace
load('../mat/emtranpma1.mat');                % nonlinear simulation
load('../mat/emstsp.mat');                    % state-space model

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
% fig 5

fig5_name = './csv/ch3_fig5.csv';             % data file
spd_idx = find(mac_state(:,2)==2);            % rotor speed state index

fig5 = figure;                                % create figure table
ax51 = subplot(2,1,1,'parent',fig5);
ax52 = subplot(2,1,2,'parent',fig5);
hold(ax51,'on');                              % always on for axis object
hold(ax52,'on');
plot(ax51, ts, x(spd_idx(1),:));
plot(ax51, ts, x(spd_idx(2),:));
plot(ax52, ts, x(spd_idx(3),:));
plot(ax52, ts, x(spd_idx(4),:));

% axis labels
xlabel(ax52,'Time (s)');
ylabel(ax51,'Speed deviation (pu)');
ylabel(ax52,'Speed deviation (pu)');

% ingraph legend
legend(ax51,{'gen1','gen2'},'location','best');
legend(ax52,{'gen3','gen4'},'location','best');

% exporting data file (both linear and nonlinear simulation data
x_spd_dec = interp1(ts,x(spd_idx,:).',tt).';  % downsampling linear data
mac_spd_dec = interp1(t,mac_spd.',tt).';      % downsampling nonlinear data

H5 = {'t','lc1','lc2','lc3','lc4','c1','c2','c3','c4'};
M5 = [tt; x_spd_dec(1,:); x_spd_dec(2,:); x_spd_dec(3,:); x_spd_dec(4,:); ...
      mac_spd_dec(1,:)-mac_spd_dec(1,1); mac_spd_dec(2,:)-mac_spd_dec(2,1); ...
      mac_spd_dec(3,:)-mac_spd_dec(3,1); mac_spd_dec(4,:)-mac_spd_dec(4,1)];

fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M5);
fclose(fid5);

% eof
