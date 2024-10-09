% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.4

% thermtss.mat: thermal turbine governor analysis

clear all; close all; clc;                    % reset workspace
load('../mat/thermtss.mat');                  % state-space model

%-------------------------------------%
% fig 5

fig5_name = './csv/ch6_fig5.csv';

fig5 = figure;
ax51 = subplot(2,1,1,'parent',fig5);
ax52 = subplot(2,1,2,'parent',fig5);
hold(ax51,'on');
hold(ax52,'on');

f = linspace(0.01,1,512);
w = 2*pi*f;

H = zeros(1,length(w));
for ii = 1:length(w)
    H(ii) = stg6.c*((1j*w(ii)*eye(size(stg6.a)) - stg6.a)\stg6.b);
end

plot(ax51,f,real(H));
plot(ax52,f,imag(H));

axis(ax51,[0,1,-5,30]);
axis(ax52,[0,1,-15,0]);

ylabel(ax51,'Real');
ylabel(ax52,'Imaginary');
xlabel(ax52,'Frequency (Hz)');

% exporting data file
H5 = {'f','real','imag'};
M5 = [f;real(H);imag(H)];

fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e\n',M5);
fclose(fid5);

% eof
