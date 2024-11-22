% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 10.1

% d2aphvdcss.mat: 2-area test case with hvdc, d2aphvdc.m (state space)

clear all; close all; clc;
load('../mat/d2aphvdcss.mat');

%-------------------------------------%
% table 1

sys_dcr = ss(a_mat,b_dcr(:,1),c_ang(3,:),d_angdcr(3,:));
sys_dcr_diff = ss(a_mat,b_dcr(:,1),(c_ang(3,:)-c_ang(9,:)),(d_angdcr(3,:)-d_angdcr(9,:)));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);

sys_dcr_rate = sys_dcr*rate;
sys_dcr_diff_rate = sys_dcr_diff*rate;

[V,d] = eig(sys_dcr_rate.a,'vector');
W = pinv(V).';                                % left eigenvectors

fence = 1:1:length(d);
mask = (real(d) > -30) & (imag(d) > 1.5);
fence = fence(mask);

for ii = 1:length(fence)
    % frequency feedback
    Ri_f(ii) = sys_dcr_rate.c*V(:,fence(ii))*W(:,fence(ii)).'*sys_dcr_rate.b;

    % frequency difference feedback
    Ri_fd(ii) = sys_dcr_diff_rate.c*V(:,fence(ii))*W(:,fence(ii)).'*sys_dcr_diff_rate.b;
end

ord = [2,3,4,5,1];                            % display order

fprintf('\nTable 1. Residues and residue angles for the two different types of feedback.\n\n');
fprintf('    Bus frequency       Frequency diff.\n');
fprintf('    Mag.     Angle      Mag.     Angle\n');
format short
disp([abs(Ri_f(ord)).',angle(Ri_f(ord).')*180/pi,abs(Ri_fd(ord)).',angle(Ri_fd(ord).')*180/pi]);
fprintf('    Eig.\n');
disp(d(fence(ord)));

% eof
