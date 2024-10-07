% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 2.2

% sbtranpma1.mat: change in torque, nonlinear simulation
% sbstsp.mat: state-space model for d2asb.m

clear all; close all; clc;              % reset workspace
load('../mat/sbtranpma1.mat');          % nonlinear simulation
load('../mat/sbstsp.mat');              % state-space model

Fs = 30;                                % sample rate
ts_step = 1e-4;                         % linear simulation time step
tt = t(1):1/Fs:t(end);                  % time vector with constant step size
ts = t(1):ts_step:t(end);               % time vector for the linearized simulation

x = zeros(size(a_mat,1),length(ts));    % linearized system state vector
dx = zeros(size(a_mat,1),length(ts));   % linearized state derivatives
u = zeros(size(mac_spd,1),length(ts));  % linearized system input vector
y = zeros(size(c_v,1),length(ts));      % linearized bus voltage vector

for ii = 1:length(ts)
    u(1,ii) = 0.01;   % change in torque at gen. 1
    u(2,ii) = -0.01;  % change in torque at gen. 2

    dx(:,ii) = a_mat*x(:,ii) + b_pm*u(:,ii);
    y(:,ii) = c_v*x(:,ii);

    if (ii < length(ts))
        x(:,ii+1) = x(:,ii) + dx(:,ii)*ts_step;  % forward euler
    end
end

%-------------------------------------%
% fig 12

fig12_name = './csv/ch3_fig12.csv';

fig12 = figure;
ax121 = subplot(1,1,1,'parent',fig12);
plot(ax121, ts, y(3,:), ts, y(8,:));

xlabel(ax121,'Time (s)');
ylabel(ax121,'Voltage magnitude (pu)');

legend(ax121,{'bus3','bus13'},'location','best');

% exporting data file (both linear and nonlinear simulation data
y_v_dec = interp1(ts,y.',tt).';       % downsampling linear data
bus_v_dec = interp1(t,bus_v.',tt).';  % downsampling nonlinear data

H12 = {'t','lc1','lc2','c3','c4'};
M12 = [tt; y_v_dec(3,:); y_v_dec(8,:); abs(bus_v_dec(3,:))-abs(bus_v(3,1));
                                       abs(bus_v_dec(8,:))-abs(bus_v(8,1))];

fid12 = fopen(fig12_name,'w');
fprintf(fid12,'%s,%s,%s,%s,%s\n',H12{:});
fprintf(fid12,'%6e,%6e,%6e,%6e,%6e\n',M12);
fclose(fid12);

% eof
