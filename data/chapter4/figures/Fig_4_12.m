% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.12

% smibncstsp.mat: nyquist analysis for single-machine infinite bus system

clear all; close all; clc;                    % reset workspace
load('../mat/smibncstsp.mat');                % state-space model

% cascading the lowpass filter
T = 0.05;                                     % time constant
a_casc = [a_mat, zeros(size(a_mat,1),1); (1/T)*c_v(1,:), -1/T];
b_casc = [b_exc; 0];
c_casc = zeros(1,size(a_casc,1));
c_casc(end) = 1;

%-------------------------------------%
% fig 12

fig12_name = './csv/ch4_figs12_13.csv';

fig12 = figure;
ax121 = subplot(1,1,1,'parent',fig12);
hold(ax121,'on');

W = 2*pi*[logspace(-3,1,2048)];               % 0.001 to 10 Hz
Hf = freqs([0,1],[0.05,1],W);                 % 1st-order lowpass filter, T=0.05s

W = [-fliplr(W),W];                           % positive and negative frequencies
Hf = [fliplr(Hf'.'),Hf];                      % filling in negative frequencies
H = zeros(1,length(W));                       % open-loop frequency response

for ii = 1:length(H)
    H(ii) = c_casc(1,:)*((1j*W(ii)*eye(size(a_casc))-a_casc)\b_casc);
end

plot(ax121,real(40*H),imag(40*H));            % K = 40
plot(ax121,-1,0,'k+','lineWidth',0.75);       % critical point

xlabel(ax121,'real (1/s)');
ylabel(ax121,'imaginary (rad/s)');
axis(ax121,[-2.5,2.5,-2,2]);

H12 = {'w','mag','ang','re','im'};
M12 = [W; abs(H); (180/pi)*angle(H); real(H); imag(H)];

% data file corresponds to unity gain
fid12 = fopen(fig12_name,'w');
fprintf(fid12,'%s,%s,%s,%s,%s\n',H12{:});
fprintf(fid12,'%6e,%6e,%6e,%6e,%6e\n',M12);
fclose(fid12);

% eof
