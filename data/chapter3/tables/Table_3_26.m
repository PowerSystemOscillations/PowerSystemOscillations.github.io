% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% table 3.26

% sbegstsp.mat: state-space model for d2asbeg.m

clear all; close all; clc;
load('../mat/sbegstsp.mat');

%-------------------------------------%
% table 26

tol = 1e-9;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

% W = pinv(Vn).';                             % left eigenvectors
Pv = V.*pinv(V).';                            % participation vectors

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(Pv,2)
    for ii = 1:size(Pv,1)
        if abs(real(Pv(ii,jj))) < tol
            Pv(ii,jj) = 0 + 1j*imag(Pv(ii,jj));
        elseif abs(imag(Pv(ii,jj))) < tol
            Pv(ii,jj) = real(Pv(ii,jj));
        end
    end
end

Pv = Pv./max(abs(Pv));                        % normalization
mask = (real(d) < 0 & imag(d) > 0);
fence = 1:1:length(d);
midx = fence(mask);
tidx = 7;

fprintf('\nTable 26. Participation vector for stable oscillatory mode 7\n\n');
fprintf('lambda = %0.4f+1j%0.4f\n\n',real(d(midx(tidx))),imag(d(midx(tidx))));
format short
%disp(Pv(:,midx(tidx)));

state_str{1} = '\Delta\delta';
state_str{2} = '\Delta\omega';
state_str{3} = '\Delta E''_{q}';
state_str{4} = '\Delta\psi_{kd}';
state_str{5} = '\Delta E''_{d}';
state_str{6} = '\Delta\psi_{kq}';
state_str{7} = '\Delta V_{tr}';
state_str{10} = '\Delta V_{a}';
state_str{21} = '\Delta tg_{1}';
state_str{22} = '\Delta tg_{2}';
state_str{23} = '\Delta tg_{3}';

jj = midx(tidx);
for ii = 1:length(Pv(:,jj))
    absPv = abs(Pv(ii,jj));
    angPv = angle(Pv(ii,jj));

    if ii <= length(Pv(:,jj))/4
        ng = 1;
    elseif ii > length(Pv(:,jj))/4 && ii <= length(Pv(:,jj))/2
        ng = 2;
    elseif ii > length(Pv(:,jj))/2 && ii <= length(Pv(:,jj))*3/4
        ng = 3;
    else
        ng = 4;
    end

    st_ii = state_str{mac_state(ii,2)};

    if (absPv > 0.1)
        fprintf('%0.0f & %s & %0.4f \\angle \\SI{%0.1f}{\\degree} \\\\\n',ng,st_ii,absPv,angPv*180/pi);
    end

    if ii == length(Pv(:,jj))
        fprintf('\\hphantom{0} \\\\\n');
    end
end

% eof
