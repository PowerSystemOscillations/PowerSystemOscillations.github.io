% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.5

clear all; close all; clc;

%-------------------------------------%
% fig 5

fig5_name = './csv/ch8_fig5.csv';

fig5 = figure;
ax51 = subplot(2,1,1,'parent',fig5);
ax52 = subplot(2,1,2,'parent',fig5);
hold(ax51,'on');
hold(ax52,'on');

w02 = [1.024050e+02, 1.514296e+02, 1.904670e+02, 2.764385e+02].^2;
betaf = 1./w02;
alphaf = [0.005, 0.001, 0.0005, 0.0001];
gammaf = [5e-7, 5e-7, 5e-7, 5e-7];

btf = [betaf(1),gammaf(1),1];                 % numerator
atf = [betaf(1),alphaf(1),1];                 % denominator
for ii = 2:length(w02)
    btf = conv(btf,[betaf(ii),gammaf(ii),1]);
    atf = conv(atf,[betaf(ii),alphaf(ii),1]);
end

[H,w] = freqs(btf,atf,2*pi*logspace(0,2,512));
f = w/2/pi;

plot(ax51,f,20*log10(abs(H)));
plot(ax52,f,(180/pi)*phase(H));

set(ax51,'xscale','log');
set(ax52,'xscale','log');
axis(ax51,[1,100,-50,5]);
axis(ax52,[1,100,-200,200]);

ylabel(ax51,'Gain (dB)');
ylabel(ax52','Phase (deg)');
xlabel(ax52,'Frequency (Hz)');

% exporting data file
H5 = {'f','g','ph'};
M5 = [f; 20*log10(abs(H)); angle(H)*180/pi];

fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s\n',H5{:});
fprintf(fid5,'%6e,%6e,%6e\n',M5);
fclose(fid5);

% eof
