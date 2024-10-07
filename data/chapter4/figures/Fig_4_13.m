% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.13

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
% fig 13

fig13 = figure;
ax131 = subplot(1,1,1,'parent',fig13);
hold(ax131,'on');

W = 2*pi*[logspace(-3,1,2048)];               % 0.001 to 10 Hz
Hf = freqs([0,1],[0.05,1],W);                 % 1st-order lowpass filter, T=0.05s

W = [-fliplr(W),W];                           % positive and negative frequencies
Hf = [fliplr(Hf'.'),Hf];                      % filling in negative frequencies
H = zeros(1,length(W));                       % open-loop frequency response

for ii = 1:length(H)
    H(ii) = c_casc(1,:)*((1j*W(ii)*eye(size(a_casc))-a_casc)\b_casc);
end

plot(ax131,real(60*H),imag(60*H));            % K = 60
plot(ax131,-1,0,'k+','lineWidth',0.75);       % critical point

xlabel(ax131,'real (1/s)');
ylabel(ax131,'imaginary (rad/s)');
axis(ax131,[-2.5,2.5,-2,2]);

% eof
