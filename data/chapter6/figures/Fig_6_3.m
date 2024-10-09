% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 6.3

% hydrotss.mat: hydro governor root locus

clear all; close all; clc;                    % reset workspace
load('../mat/hydrotss.mat');                  % state-space model

%-------------------------------------%
% fig 3

fig3_name = './csv/ch6_fig3.csv';

fig3 = figure;
ax31 = subplot(2,1,1,'parent',fig3);
ax32 = subplot(2,1,2,'parent',fig3);
hold(ax31,'on');
hold(ax32,'on');

f = linspace(0.01,1,512);
w = 2*pi*f;

H = zeros(1,length(w));
Hc = zeros(1,length(w));
for ii = 1:length(w)
    H(ii) = shg6.c(1,:)*((1j*w(ii)*eye(size(shg6.a)) - shg6.a)\shg6.b);
    % Hc(ii) = shg4g.c(1,:)*((1j*w(ii)*eye(size(shg4g.a)) - shg4g.a)\shg4g.b);
end

plot(ax31,f,real(H));
plot(ax32,f,imag(H));
% plot(ax31,f,real(Hc),'.');
% plot(ax32,f,imag(Hc),'.');
ylabel(ax31,'Real');
ylabel(ax32,'Imaginary');
xlabel(ax32,'Frequency (Hz)');

% exporting data file
H3 = {'f','real','imag'};
M3 = [f;real(H);imag(H)];

fid3 = fopen(fig3_name,'w');
fprintf(fid3,'%s,%s,%s\n',H3{:});
fprintf(fid3,'%6e,%6e,%6e\n',M3);
fclose(fid3);

% eof
