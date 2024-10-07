% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.10

clear all; close all; clc;

fig10_name = './csv/ch3_fig10.csv';
fig10 = figure;
ax101 = subplot(1,1,1,'parent',fig10);
hold(ax101,'on');

Fs = 30;                         % sample rate
ts_step = 1e-3;                  % linear simulation time step
ts = 0:ts_step:15;               % time vector for simulation
tt = ts(1):1/Fs:ts(end);         % time vector for exporting

m = 5;                           % mass (arbitrary)
fn = 1;                          % undamped natural frequency (Hz)
k = m*(2*pi*fn)^2;               % stiffness coefficient

damp = [0.0, 0.05, 0.1, 0.2];    % damping ratios
for ii = 1:length(damp)
    c = damp(ii)*(2*sqrt(m*k));  % damping coefficient
    A = [-c/m, -k/m; 1, 0];      % state matrix
    B = [4;0];                   % input sensitivity

    x{ii} = zeros(2,length(ts));
    dx{ii} = zeros(2,length(ts));

    for jj = 1:length(ts)
      % x{ii}(:,1) = [0;0.1];    % optional off-nominal initial condition
        dx{ii}(:,jj) = A*x{ii}(:,jj) + B*1;
        if jj < length(ts)
            x{ii}(:,jj+1) = x{ii}(:,jj) + ts_step*dx{ii}(:,jj);
            dx_heun = A*x{ii}(:,jj+1) + B*1;
            x{ii}(:,jj+1) = x{ii}(:,jj) + ts_step*(dx{ii}(:,jj) + dx_heun)/2;
        end
    end

    plot(ax101,ts,x{ii}(2,:));
end

v = axis(ax101);
axis(ax101,[v(1) v(2) -0.085 v(4)]);
legend(ax101,{'$\zeta=0.00$','$\zeta=0.05$','$\zeta=0.10$','$\zeta=0.20$'}, ...
       'interpreter','latex','location','southeast');

xlabel(ax101,'Time (s)');
ylabel(ax101,'Response');

x1_dec = zeros(length(damp),length(tt));
for ii = 1:length(damp)
    x1_dec(ii,:) = interp1(ts,x{ii}(2,:),tt);  % downsampling
end

H10 = {'t','rz1','rz2','rz3','rz4'};           % 5 channels total
M10 = [tt; x1_dec];

fid10 = fopen(fig10_name,'w');
fprintf(fid10,'%s,%s,%s,%s,%s\n',H10{:});
fprintf(fid10,'%6e,%6e,%6e,%6e,%6e\n',M10);
fclose(fid10);

% eof
