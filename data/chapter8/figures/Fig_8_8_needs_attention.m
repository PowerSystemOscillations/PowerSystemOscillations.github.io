% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 8.8

% datalaag_smib_tor.mat:

clear all; close all; clc;
load('../mat/original/datalaag_smib_tor.mat');

%-------------------------------------%
% fig 8

a_mat = smib_tor.a_mat;
b_vr = smib_tor.b_vr;
c_p = smib_tor.c_p(1,:);

fig8_name = './csv/ch8_fig8.csv';

fig8 = figure;
ax81 = subplot(2,1,1,'parent',fig8);
ax82 = subplot(2,1,2,'parent',fig8);
hold(ax81,'on');
hold(ax82,'on');

H = 3.558;                                    % inertia constant

% compensation parameters
Tw = 1.41;
Tn1 = 0.154;
Td1 = 0.033;

Hpss = tf([Tw,0],[Tw,1])*tf([Tn1,1],[Td1,1]);
Gp = ss(a_mat,b_vr,c_p,0);
Gp = series(Gp,[tf([0,1],[1,0])]);
Gpss = series(Hpss,Gp);

f = logspace(0,2,256);
w = 2*pi*f;
H_casc = zeros(1,length(f));
for ii = 1:length(f)
    H_casc(ii) = Gpss.C*((1j*w(ii)*eye(size(Gpss.A)) - Gpss.A)\Gpss.B);
end

plot(ax81,f,20*log10(abs(H_casc)));
plot(ax82,f,angle(H_casc)*180/pi);
set(ax81,'xscale','log');
set(ax82,'xscale','log');
% axis(ax81,[1,100,-140,0]);

% legend(ax81,'model','analytical','location','southEast');

ylabel(ax81,'Gain (dB)');
ylabel(ax82,'Phase (deg)');
xlabel(ax82,'Frequency (Hz)');

axis(ax81,[1,100,-100,20]);

% exporting data file
H8 = {'f','g','ph'};
M8 = [f; 20*log10(abs(H_casc)); angle(H_casc)*180/pi];

fid8 = fopen(fig8_name,'w');
fprintf(fid8,'%s,%s,%s\n',H8{:});
fprintf(fid8,'%6e,%6e,%6e\n',M8);
fclose(fid8);

% eof
