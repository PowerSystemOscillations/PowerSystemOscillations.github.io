clear all; close all; clc; 

%% table 1

load('emstsp.mat');
tol = 1e-7;

[~,D] = eig(a_mat);
d = sort(diag(D),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

fprintf('\nTable 1. Eigenvalues of the classical generator model\n\n');
format short
disp(d)

%% tables 2, 3, and 4

clear all; close all; clc;
load('emstsp.mat');
tol = 1e-7;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

Vn = zeros(size(V));
for ii = 1:size(V,2)
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);            % post-normalization
end

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(Vn,2)
    for ii = 1:size(Vn,1)
        if abs(real(Vn(ii,jj))) < tol
            Vn(ii,jj) = 0 + 1j*imag(Vn(ii,jj));
        elseif abs(imag(Vn(ii,jj))) < tol
            Vn(ii,jj) = real(Vn(ii,jj));
        end
    end
end

fprintf('\nTable 2. Right eigenvectors for real eigenvalues\n\n');
fprintf('lambda = %0.4f, lambda = %0.4f\n\n',d(1),d(2));
format shorte
disp([Vn(:,1),Vn(:,2)])

fprintf('Table 3. Right eigenvector for the inter-area mode\n\n');
fprintf('lambda = %0.4f+j%0.4f\n\n',real(d(4)),imag(d(4)));
format short
disp(Vn(:,4))
for ii = 1:length(Vn(:,4))
    if abs(real(Vn(ii,4))) > 0
        fprintf('%0.4f\n',real(Vn(ii,4)));
    else
        if imag(Vn(ii,4)) > 0
            fprintf('j%0.4f\n',imag(Vn(ii,4)));
        else
            fprintf('-j%0.4f\n',abs(imag(Vn(ii,4))));
        end
    end
end
fprintf('\n');

fprintf('Table 4. Right eigenvectors for the local modes\n\n');
fprintf('lambda = %0.4f+j%0.4f, lambda = %0.4f+j%0.4f\n\n', ...
        real(d(6)),imag(d(6)),real(d(8)),imag(d(8)));
format short
disp([Vn(:,6),Vn(:,8)])
for ii = 1:length(Vn(:,8))
    if abs(real(Vn(ii,8))) > 0
        fprintf('%0.4f\n',real(Vn(ii,8)));
    else
        if imag(Vn(ii,8)) > 0
            fprintf('j%0.4f\n',imag(Vn(ii,8)));
        else
            fprintf('-j%0.4f\n',abs(imag(Vn(ii,8))));
        end
    end
end
fprintf('\n');

%% tables 5, 6, and 7

clear all; close all; clc;
load('emstsp.mat');
tol = 1e-7;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

Vn = zeros(size(V));
for ii = 1:size(V,2)
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);            % post-normalization
end

W = pinv(Vn).';                             % left eigenvectors

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(W,2)
    for ii = 1:size(W,1)
        if abs(real(W(ii,jj))) < tol
            W(ii,jj) = 0 + 1j*imag(W(ii,jj));
        elseif abs(imag(W(ii,jj))) < tol
            W(ii,jj) = real(W(ii,jj));
        end
    end
end

% publication note: do not use scientific notation here
fprintf('Table 5. Left eigenvectors for real eigenvalues\n\n');
fprintf('lambda = %0.4f+j%0.4f\nlambda = %0.4f+j%0.4f\n\n', ...
        real(d(1)),imag(d(1)),real(d(2)),imag(d(2)));
format shortg
disp([W(:,1).'; W(:,2).'])

fprintf('Table 6. Left eigenvector for the inter-area mode\n\n');
fprintf('lambda = %0.4f+j%0.4f\n\n',real(d(4)),imag(d(4)));
format short
disp(W(:,4).')

fprintf('Table 7. Left eigenvectors for the local modes\n\n');
fprintf('lambda = %0.4f+j%0.4f\nlambda = %0.4f+j%0.4f\n\n', ...
        real(d(6)),imag(d(6)),real(d(8)),imag(d(8)));
format short
disp([W(:,6).'; W(:,8).'])

%% table 8

clear all; close all; clc;
load('emmistsp.mat');
tol = 1e-7;

[~,D] = eig(a_mat);
d = sort(diag(D),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

fprintf('\nTable 8. Eigenvalues of the modified system\n\n');
format short
disp(d)

%% table 9

clear all; close all; clc;
load('emmistsp.mat');
tol = 1e-7;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

Vn = zeros(size(V));
for ii = 1:size(V,2)
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);            % post-normalization
end

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(Vn,2)
    for ii = 1:size(Vn,1)
        if abs(real(Vn(ii,jj))) < tol
            Vn(ii,jj) = 0 + 1j*imag(Vn(ii,jj));
        elseif abs(imag(Vn(ii,jj))) < tol
            Vn(ii,jj) = real(Vn(ii,jj));
        end
    end
end

fprintf('\nTable 9. Right eigenvectors of the modified system (cols 1, 2)\n\n');
fprintf('lambda = %0.4f, lambda = %0.4f\n\n',d(1),d(2));
format shorte
disp([Vn(:,1),Vn(:,2)])

fprintf('\nTable 9. Right eigenvectors of the modified system (cols 3--5)\n\n');
fprintf('lambda = %0.4f+j%0.4f,lambda = %0.4f+j%0.4f,lambda = %0.4f+j%0.4f\n\n', ...
        real(d(4)),imag(d(4)),real(d(6)),imag(d(6)),real(d(8)),imag(d(8)));
format short
disp([Vn(:,4),Vn(:,6),Vn(:,8)])

%% tables 10 and 11

clear all; close all; clc;
load('emstsp.mat');
tol = 1e-7;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

Vn = zeros(size(V));
for ii = 1:size(V,2)
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);            % post-normalization
end

% W = pinv(Vn).';                           % left eigenvectors
Pv = V.*pinv(V).';                          % participation vectors

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

fprintf('\nTable 10. Participation vector for the inter-area mode\n\n');
fprintf('lambda = %0.4f+1j%0.4f\n\n',real(d(4)),imag(d(4)));
format short
disp(Pv(:,4))

fprintf('\nTable 11. Participation vectors for the local modes\n\n');
fprintf('lambda = %0.4f+1j%0.4f, lambda = %0.4f+1j%0.4f\n\n',...
        real(d(6)),imag(d(6)),real(d(8)),imag(d(8)));
format short
disp([Pv(:,6), Pv(:,8)])

%% tables 12, 13, and 14

clear all; close all; clc;
load('sbstsp.mat');
tol = 1e-7;

[~,D] = eig(a_mat);
d = sort(diag(D),'ascend');

a_matm = a_mat;
spd_idx = find(mac_state(:,2) == 2);
for ii = 1:length(spd_idx)
    a_matm(spd_idx(ii),spd_idx(ii)) = a_matm(spd_idx(ii),spd_idx(ii)) - 0.5;
end

[~,Dm] = eig(a_matm);
dm = sort(diag(Dm),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for ii = 1:length(dm)
    if abs(real(dm(ii))) < tol
        dm(ii) = 0 + 1j*imag(dm(ii));
    elseif abs(imag(dm(ii))) < tol
        dm(ii) = real(dm(ii));
    end
end

fprintf('\nTable 12. Eigenvalues of the system with detailed generator models\n\n');
format short
disp(d)

fprintf('\nTable 13. Damping ratio and frequency of the electromechanical oscillations f\n\n');
fprintf('Damping ratio, Frequency (Hz)\n\n');
format short
mask = (real(d) < 0 & imag(d) > 0);
disp([-cos(angle(d(mask))),imag(d(mask))/2/pi])
fprintf('Eigenvalue\n\n');
disp(d(mask));

fprintf('\nTable 14. Eigenvalues of the system with modified damping coefficients\n\n');
format short
disp(dm)

%% table 15

clear all; close all; clc;
load('sbegstsp.mat');
tol = 1e-7;

[~,D] = eig(a_mat);
d = sort(diag(D),'ascend');

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

fprintf('\nTable 15. Eigenvalues for system with detailed generator models and controls\n\n');
format short
disp(d)

%% tables 16 and 17

clear all; close all; clc;
load('sbegstsp.mat');
tol = 1e-9;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

Vn = zeros(size(V));
for ii = 1:size(V,2)
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);            % post-normalization
end

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(Vn,2)
    for ii = 1:size(Vn,1)
        if abs(real(Vn(ii,jj))) < tol
            Vn(ii,jj) = 0 + 1j*imag(Vn(ii,jj));
        elseif abs(imag(Vn(ii,jj))) < tol         
            Vn(ii,jj) = real(Vn(ii,jj));
        end
    end
end

format shorte
fprintf('\nTable 16. Right eigenvector for the zero eigenvalue\n\n');
fprintf('lambda = %0.4f\n\n',d(1));
disp(Vn(:,1))

format short
fprintf('\nTable 17. Right eigenvector for the unstable complex mode\n\n');
fprintf('lambda = %0.4f + j%0.4f\n\n',real(d(16)),imag(d(16)));
disp(Vn(:,16))
disp([abs(Vn(:,16)),round(angle(Vn(:,16))*180/pi,1)])

%% tables 18 and 19

clear all; close all; clc;
load('sbegstsp.mat');
tol = 1e-9;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

Vn = zeros(size(V));
for ii = 1:size(V,2)
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);            % post-normalization
end

% W = pinv(Vn).';                           % left eigenvectors
Pv = V.*pinv(V).';                          % participation vectors

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

Pv = Pv./max(abs(Pv));  % valid way to normalize participation factors
fprintf('\nTable 18. Participation vector for the unstable inter-area mode\n\n');
fprintf('lambda = %0.4f+1j%0.4f\n\n',real(d(16)),imag(d(16)));
format short
fprintf('%0.4f \\angle \\SI{%0.1f}{\\degree}\n',[abs(Pv(:,16)),angle(Pv(:,16))*180/pi].');

fprintf('\nTable 19. Stable oscillatory modes\n\n');
fprintf('Damping ratio, Frequency (Hz)\n\n');
format short
mask = (real(d) < 0 & imag(d) > 0);
disp([-cos(angle(d(mask))),imag(d(mask))/2/pi])
fprintf('Eigenvalue\n\n');
disp(d(mask));

%% tables 20--28

clear all; close all; clc;
load('sbegstsp.mat');
% load('d2asbeg_ch3_stsp.mat');
tol = 1e-9;

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
V = V(:,J);

% W = pinv(Vn).';                           % left eigenvectors
Pv = V.*pinv(V).';                          % participation vectors

% replacing tiny values with zeros
for ii = 1:length(d)
    if abs(real(d(ii))) < tol
        d(ii) = 0 + 1j*imag(d(ii));
    elseif abs(imag(d(ii))) < tol
        d(ii) = real(d(ii));
    end
end

for jj = 1:size(Pv,2)
    % CAUTION: WRONG WAY TO NORMALIZE BUT MATCHES GRAHAM
    % [M,I] = max(abs(Pv(:,jj)),[],'linear');
    % Pv(:,jj) = Pv(:,jj)./Pv(I,jj);
    
    for ii = 1:size(Pv,1)
        if abs(real(Pv(ii,jj))) < tol
            Pv(ii,jj) = 0 + 1j*imag(Pv(ii,jj));
        elseif abs(imag(Pv(ii,jj))) < tol
            Pv(ii,jj) = real(Pv(ii,jj));
        end
    end
end

Pv = Pv./max(abs(Pv));  % valid way to normalize participation factors
mask = (real(d) < 0 & imag(d) > 0);
fence = 1:1:length(d);
midx = fence(mask);
tidx = 5;

fprintf('\nTable 20. Participation vector for stable oscillatory mode 1\n\n');
fprintf('lambda = %0.4f+1j%0.4f\n\n',real(d(midx(tidx))),imag(d(midx(tidx))));
format short
disp(Pv(:,midx(tidx)));

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
    
%     if ii <= length(Pv(:,jj))/2 && abs(Pv(ii,jj)) > 0.1
%         if rePv > 0 && imPv > 0
%             fprintf('%0.0f & %s & \\hphantom{-}%0.4f + j%0.4f \\\\\n',ng,st_ii,rePv,abs(imPv));
%         elseif rePv > 0 && imPv < 0
%             fprintf('%0.0f & %s & \\hphantom{-}%0.4f - j%0.4f \\\\\n',ng,st_ii,rePv,abs(imPv));
%         elseif rePv < 0 && imPv > 0     
%             fprintf('%0.0f & %s & %0.4f + j%0.4f \\\\\n',ng,st_ii,rePv,abs(imPv));
%         else
%             fprintf('%0.0f & %s & %0.4f - j%0.4f \\\\\n',ng,st_ii,rePv,abs(imPv));
%         end
%     elseif ii > length(Pv(:,jj))/2 && abs(Pv(ii,jj)) > 0.1
%         if rePv > 0 && imPv > 0
%             fprintf('%0.0f & %s & \\hphantom{-}%0.4f + j%0.4f \\\\\n',ng,st_ii,rePv,abs(imPv));
%         elseif rePv > 0 && imPv < 0
%             fprintf('%0.0f & %s & \\hphantom{-}%0.4f - j%0.4f \\\\\n',ng,st_ii,rePv,abs(imPv));
%         elseif rePv < 0 && imPv > 0     
%             fprintf('%0.0f & %s & %0.4f + j%0.4f \\\\\n',ng,st_ii,rePv,abs(imPv));
%         else
%             fprintf('%0.0f & %s & %0.4f - j%0.4f \\\\\n',ng,st_ii,rePv,abs(imPv));
%         end
%     end
    
    if ii == length(Pv(:,jj))
        fprintf('\\hphantom{0} \\\\\n');
    end
end

%%

load('sbstsp.mat');

[V,D] = eig(a_mat);
[d,J] = sort(diag(D),'ascend');
D = diag(d); 
V = V(:,J);
n_eig = size(a_mat,1);

Vn = zeros(size(V));
for ii = 1:n_eig
    [M,I] = max(abs(V(:,ii)),[],'linear');
    Vn(:,ii) = V(:,ii)./V(I,ii);            % post-normalization
end

W = pinv(Vn).';                             % left eigenvectors
Pv = V.*pinv(V).';                          % participation vectors

%%
