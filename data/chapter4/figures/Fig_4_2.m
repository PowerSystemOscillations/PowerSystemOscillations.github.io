% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.2

% sbstsp.mat: state-space model for d2asb.m

clear all; close all; clc;                    % reset workspace
load('../mat/sbstsp.mat');                    % state-space model

%-------------------------------------%
% fig 2

fig2 = figure;
ax12 = subplot(1,1,1,'parent',fig2);
hold(ax12,'on');

for ii = 1:size(rlexcgen1,2)
    plot(ax12,real(rlexcgen1(:,ii)),imag(rlexcgen1(:,ii)),...
         'bd','markerFaceColor','b','markerSize',3.5);
end

for ii = 1:size(rlexcgen1,2)
    if (ii == 1001)
        plot(ax12,real(rlexcgen1(:,ii)),imag(rlexcgen1(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax12,real(rlexcgen1(:,ii)),imag(rlexcgen1(:,ii)),...
             'rs','markerSize',8.5);
    end
end

const_damping_x = [-220,0];
const_damping_y = [220*tan(acos(0.05)),0];

plot(ax12,real(rlexcgen1(:,1)),imag(rlexcgen1(:,1)),'r+','lineWidth',0.75);
plot(ax12,const_damping_x,const_damping_y,'k-');

xlabel(ax12,'real (1/s)');
ylabel(ax12,'imaginary (rad/s)');
axis(ax12,[-6,1,0,10]);

% eof
