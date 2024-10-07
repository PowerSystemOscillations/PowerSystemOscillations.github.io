% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.14

% smibc.mat: smib model for generator 1, state-space

clear all; close all; clc;                    % reset workspace
load('../mat/smibc.mat');                     % state-space model

%-------------------------------------%
% fig 14

fig14_name = './csv/ch4_fig14.csv';

fig14 = figure;
ax141 = subplot(2,1,1,'parent',fig14);
ax142 = subplot(2,1,2,'parent',fig14);
hold(ax141,'on');
hold(ax142,'on');

H_T = @(s) cp*((s*eye(size(ak))-ak)\(ba + s*bs/(2*pi*60))) + (dpa + s*dps);

f = 0.1:0.01:5;
Td = zeros(size(f));
Ts = zeros(size(f));
for ii = 1:length(f)
    tmp1 = H_T(1j*2*pi*f(ii));
    Ts(ii) = real(tmp1);
    Td(ii) = imag(tmp1)/(2*pi*f(ii));
end

plot(ax141,f,Ts);
plot(ax142,f,Td);

axis(ax141,[0,5,0.5,1.2]);
axis(ax142,[0,5,-0.05,0.02]);

ylabel(ax141,'synchr. torque (pu)');
ylabel(ax142,'damping torque (pu)');
xlabel(ax142,'frequency (Hz)');

H14 = {'f','Ts','Td'};
M14 = [f; Ts; Td];

% data file corresponds to unity gain
fid14 = fopen(fig14_name,'w');
fprintf(fid14,'%s,%s,%s\n',H14{:});
fprintf(fid14,'%6e,%6e,%6e\n',M14);
fclose(fid14);

% eof
