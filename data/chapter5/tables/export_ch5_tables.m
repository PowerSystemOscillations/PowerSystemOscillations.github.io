%% table 1

clear all; close all; clc;
load('data4memstsp.mat');

fprintf('\nTable 1. State matrix of the 4-generator plant.\n\n');
format short
disp(a_mat);

%% table 2

clear all; close all; clc;
load('data4memstsp.mat');
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

fprintf('\nTable 2. Eigenvalues of the 4-generator plant.\n\n');
format short
disp(d);

%% table 3

clear all; close all; clc;
load('data4magemstsp.mat');

fprintf('\nTable 3. State matrix of the aggregate plant.\n\n');
format short
disp(a_mat);

%% table 4

clear all; close all; clc;
load('data4magemstsp.mat');
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

fprintf('\nTable 4. Eigenvalues of the aggregate plant model.\n\n');
format short
disp(d);

%% tables 5--8

clear all; close all; clc;
load('data4memstsp.mat');
tol = 1e-7;

P = eye(8);
P(3:4,1:2) = eye(2);
P(5:6,1:2) = eye(2);
P(7:8,1:2) = eye(2);

a_mat = P\(a_mat*P);
a_mat(abs(a_mat) < tol) = 0;

fprintf('\nTable 5. Transformation matrix.\n\n');
format short
disp(P);

fprintf('\nTable 6. Transformed state matrix of the 4-generator plant.\n\n');
format short
disp(a_mat);

fprintf('\nTable 7. Eigenvalues of the first 2-by-2 block.\n\n');
format short
disp(eig(a_mat(1:2,1:2)));

fprintf('\nTable 8. Eigenvalues of the other 2-by-2 blocks.\n\n');
format short
disp(eig(a_mat(3:4,3:4)));

%% table 9

clear all; close all; clc;
load('data4memstsp.mat');
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

fprintf('\nTable 9. Right eigenvector of the plant mode.\n\n');
fprintf('lambda = 0 + j%0.4f\n\n',imag(d(2)));
format short
disp(Vn(:,2));

%% table 10

clear all; close all; clc;
load('16memstsp.mat');
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

fprintf('\nTable 10. Resonant frequencies of the 16-generator system.\n\n');
format short
mask = (imag(d) >= 0);
disp(sort(imag(d(mask).'))/2/pi)

%% table 11

clear all; close all; clc;
load('16memstsp.mat');

ang_idx = 1:2:size(a_mat,1);  % rotor angle state index
ref_idx = [15,14,16,5,13];    % reference generators
coh_eigs_idx = 1:1:10;        % electromechanical modes

% u - eigenvector matrix, l - eigenvalues
W_ref = u(ang_idx(ref_idx),coh_eigs_idx);
W_gen = u(ang_idx,coh_eigs_idx);
W_bus = c_ang*u(:,coh_eigs_idx);

n_ref = size(W_ref,1);
n_gen = size(W_gen,1);
n_bus = size(W_bus,1);

G_full = zeros(n_gen,n_gen);  % coherency matrix with all gens included
for ii = 1:n_gen
    for jj = 1:n_gen
        G_full(ii,jj) = abs(W_gen(ii,:)*W_gen(jj,:).') ...
                       /(norm(W_gen(ii,:),2)*norm(W_gen(jj,:),2));
    end
end

fprintf('\nTable 11a. Coherency matrix part 1.\n\n');
format short
disp(G_full(:,1:8));

fprintf('\nTable 11b. Coherency matrix part 2.\n\n');
format short
disp(G_full(:,9:end));

%% tables 12-16

clear all; close all; clc;    % reset workspace
load('16memstsp.mat');        % state-space model

ang_idx = 1:2:size(a_mat,1);  % rotor angle state index
ref_idx = [15,14,16,5,13];    % reference generators
coh_eigs_idx = 1:1:10;        % electromechanical modes

% u - eigenvector matrix, l - eigenvalues
W_ref = u(ang_idx(ref_idx),coh_eigs_idx);
W_gen = u(ang_idx,coh_eigs_idx);
W_bus = c_ang*u(:,coh_eigs_idx);

n_ref = size(W_ref,1);
n_gen = size(W_gen,1);
n_bus = size(W_bus,1);

G_full = zeros(n_gen,n_gen);  % coherency matrix with all gens included
for ii = 1:n_gen
    for jj = 1:n_gen
        G_full(ii,jj) = abs(W_gen(ii,:)*W_gen(jj,:).') ...
                       /(norm(W_gen(ii,:),2)*norm(W_gen(jj,:),2));
    end
end

G_gen = zeros(n_ref,n_gen);   % coherency matrix with reference gens only
for ii = 1:n_ref
    for jj = 1:n_gen
        G_gen(ii,jj) = abs(W_ref(ii,:)*W_gen(jj,:).') ...
                       /(norm(W_ref(ii,:),2)*norm(W_gen(jj,:),2));
    end
end

G_bus = zeros(n_ref,n_bus);   % coherency matrix for bus voltage angles
for ii = 1:n_ref
    for jj = 1:n_bus
        G_bus(ii,jj) = abs(W_ref(ii,:)*W_bus(jj,:).') ...
                       /(norm(W_ref(ii,:),2)*norm(W_bus(jj,:),2));
    end
end

line = [...
         1   2;
         1  27;
         8   9;
        40  48;
        41  42;
        42  52;
        49  52;
        50  51];
    
gmax = 0;
for ii = 1:length(ref_idx)
    % generator coherency groups
    [~,midx] = max(G_gen,[],1);
    tmp = 1:1:n_gen;
    group(ii).gens = tmp(midx == ii);
    
    if (length(group(ii).gens) > gmax)
        gmax = length(group(ii).gens);
    end
    
    % bus coherency groups
    [~,midx] = max(G_bus,[],1);
    tmp = 1:1:n_bus; 
    group(ii).buses = tmp(midx == ii);
    
    group(ii).frombus = [];
    group(ii).tobus = [];
    mask = false(size(line,1),1);
    
    for jj = 1:length(group(ii).buses)
        from_mask = (group(ii).buses(jj) == line(:,1));
        to_mask = (group(ii).buses(jj) == line(:,2));
        mask = (mask | from_mask | to_mask);
    end
    
    group(ii).frombus = [group(ii).frombus, line(mask,1).'];
    group(ii).tobus = [group(ii).tobus, line(mask,2).'];
end

fprintf('\nTable 12. Group 1: Reference generator 15.\n\n');
format short
fprintf('Generators: '); fprintf('%2.0f  ',group(1).gens.');
fprintf('\nBuses:      '); fprintf('%2.0f  ',group(1).buses.');
fprintf('\nFrom bus:   '); fprintf('%2.0f  ',group(1).frombus.');
fprintf('\nTo bus:     '); fprintf('%2.0f  ',group(1).tobus.');

fprintf('\n\nTable 13. Group 2: Reference generator 14.\n\n');
format short
fprintf('Generators: '); fprintf('%2.0f  ',group(2).gens.');
fprintf('\nBuses:      '); fprintf('%2.0f  ',group(2).buses.');
fprintf('\nFrom bus:   '); fprintf('%2.0f  ',group(2).frombus.');
fprintf('\nTo bus:     '); fprintf('%2.0f  ',group(2).tobus.');

fprintf('\n\nTable 14. Group 3: Reference generator 16.\n\n');
format short
fprintf('Generators: '); fprintf('%2.0f  ',group(3).gens.');
fprintf('\nBuses:      '); fprintf('%2.0f  ',group(3).buses.');
fprintf('\nFrom bus:   '); fprintf('%2.0f  ',group(3).frombus.');
fprintf('\nTo bus:     '); fprintf('%2.0f  ',group(3).tobus.');

fprintf('\n\nTable 15. Group 4: Reference generator 5.\n\n');
format short
fprintf('Generators: '); fprintf('%2.0f  ',group(4).gens.');
fprintf('\nBuses:      '); fprintf('%2.0f  ',group(4).buses(1:18).');
fprintf('\n            '); fprintf('%2.0f  ',group(4).buses(19:end).');
fprintf('\nFrom bus:   '); fprintf('%2.0f  ',group(4).frombus.');
fprintf('\nTo bus:     '); fprintf('%2.0f  ',group(4).tobus.');

fprintf('\n\nTable 16. Group 5: Reference generator 13.\n\n');
format short
fprintf('Generators: '); fprintf('%2.0f  ',group(5).gens.');
fprintf('\nBuses:      '); fprintf('%2.0f  ',group(5).buses(1:18).');
fprintf('\n            '); fprintf('%2.0f  ',group(5).buses(19:end).');
fprintf('\nFrom bus:   '); fprintf('%2.0f  ',group(5).frombus.');
fprintf('\nTo bus:     '); fprintf('%2.0f  ',group(5).tobus.');
fprintf('\n\n');

%% table 17

line = {...
   '52' '42'  '0.0040'  '0.0600'  '2.2500'  '1,3';
   '42' '41'  '0.0040'  '0.0600'  '2.2500'  '1,2';
   '48' '40'  '0.0020'  '0.0220'  '1.2800'  '2,5';
   '49' '52'  '0.0076'  '0.1141'  '1.1600'  '3,5';
   '50' '51'  '0.0009'  '0.0221'  '1.6200'  '3,5';
   ' 1' ' 2'  '0.0035'  '0.0411'  '0.6987'  '4,5';
   ' 1' '27'  '0.0320'  '0.3200'  '0.4100'  '4,5';
   ' 8' ' 9'  '0.0023'  '0.0363'  '0.3804'  '4,5'};

fprintf('\n\nTable 17. Tie line data.\n\n');
fprintf('     from       to          R             X             B         groups\n');
format short;
disp(line);

%% table 18

clear all; close all; clc;    % reset workspace
load('16m1tstsp.mat');        % state-space model
tol = 1e-7;

[~,D] = eig(a_mat);
tmp = diag(D);
d1t = sort(tmp(abs(imag(tmp)) > tol),'ascend');
mask = abs(imag(d1t)) > 2.3 & abs(imag(d1t)) < 5;
d1t = d1t(mask);

load('16m3tstsp.mat');        % state-space model

[~,D] = eig(a_mat);
d3t = sort(diag(D),'ascend');
mask = abs(imag(d3t)) > 2.4 & abs(imag(d3t)) < 5;
d3t = d3t(mask);

fprintf('\n\nTable 18. Low frequency modes.\n\n');
fprintf('   one tie line       three tie lines\n');
format short;
disp([d1t,d3t]);

fprintf('Table 18 cont. Low frequency mode frequencies.\n\n');
fprintf('one tie (Hz)  three ties (Hz)\n');
format short;
disp([imag(d1t(2:2:end))/2/pi,imag(d3t(2:2:end))/2/pi]);

% eof