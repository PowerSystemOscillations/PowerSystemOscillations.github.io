%%
% 16memstsp: 16-machine system with classical generator models
% 16m1tstsp: 16-machine system with generator controls and 1 tie
% 16m3tstsp: 16-machine system with generator controls and 3 ties
% 16m2ttran: 16-machine system simulations with 2 ties

%%
% 16memstsp: 16-machine system with classical generator models, data16em.m

clear all; close all; clc;    % reset workspace
load('16memstsp.mat');        % state-space model

%-------------------------------------%
% fig 2

fig2_name = './dat/ch5_fig2.dat';

fig2 = figure;
ax21 = subplot(1,1,1,'parent',fig2);
hold(ax21,'on');

ang_idx = 1:2:size(a_mat,1);  % rotor angle state index
ref_idx = [15,14,16,5,13];    % reference generators
coh_eigs_idx = 2:2:10;        % electromechanical modes

% u - eigenvector matrix, l - eigenvalues
W_ref = u(ang_idx(ref_idx),coh_eigs_idx);
W_gen = u(ang_idx,coh_eigs_idx);
W_bus = c_ang*u(:,coh_eigs_idx);
% W_bus = [u(ang_idx(ref_idx),coh_eigs_idx); c_ang(:,ang_idx)*u(ang_idx,coh_eigs_idx)];

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
    
    % plotting generator groups
    plot(ax21,ii*ones(size(group(ii).gens)),group(ii).gens,'b*');
end

set(ax21,'ydir','reverse');
xlabel(ax21,'Group number');
ylabel(ax21,'Generator number');

H2 = {'k1','g1','k2','g2','k3','g3','k4','g4','k5','g5'};
M2 = -1*ones(2*numel(group),gmax);
for ii = 1:numel(group)
    M2(2*ii-1,:) = ii;
    M2(2*ii,1:length(group(ii).gens)) = group(ii).gens;
end

% group gen | group gen | etc.
fid2 = fopen(fig2_name,'w');
fprintf(fid2,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H2{:});         % must match number of columns
fprintf(fid2,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M2);  % must match number of columns
fclose(fid2);

%% 
% fig 4
clear all; close all; clc;     % reset workspace
load('16memstsp.mat');         % state-space model

fig4_name = './dat/ch5_fig4.dat';

ang_idx = 1:2:size(a_mat,1);  % rotor angle state index
eigs_idx = 2:2:10;            % electromechanical modes

fig4 = figure;
for ii = 1:5
    ax4{ii} = subplot(5,1,ii,'parent',fig4);
    hold(ax4{ii},'on');
end

% normalizing the rotor angle eigenvectors
V_ang = u(ang_idx,:);
[vmax,vidx] = max(abs(real(V_ang)),[],1,'linear');
V_ang = V_ang*diag(1./(vmax.*sign(V_ang(vidx))));

for ii = 1:numel(ax4)
    bar(ax4{ii},real(V_ang(:,eigs_idx(ii))));
    axis(ax4{ii},[0,17,-1,1]);
    ylabel(ax4{ii},['eig',num2str(ii)]);
end

xlabel(ax4{end},'Generator number');

H4 = {'k','v1','v2','v3','v4','v5'};
M4 = [1:1:size(V_ang,1); real(V_ang(:,eigs_idx)).'];

% gen | v1 | v2 | etc.
fid4 = fopen(fig4_name,'w');
fprintf(fid4,'%s,%s,%s,%s,%s,%s\n',H4{:});     % must match number of columns
fprintf(fid4,'%6e,%6e,%6e,%6e,%6e,%6e\n',M4);  % must match number of columns
fclose(fid4);

%%
% 16m1tstsp: 16-machine system with a single tie between areas 4 and 5

clear all; close all; clc;     % reset workspace
load('16m1tstsp.mat');         % state-space model

%-------------------------------------%
% figs 

fig5_name = './dat/ch5_fig5.dat';

fig5 = figure;
for ii = 1:5
    ax5{ii} = subplot(5,1,ii,'parent',fig5);
    hold(ax5{ii},'on');
end

[V,~] = eig(a_mat);
ang_mask = (mac_state(:,2) == 1);  % rotor angle state index
eigs_idx = [105,73,71,69,67];      % eigenvalues of interest
V_ang = V(ang_mask,:);

% normalizing the rotor angle eigenvectors
[vmax,vidx] = max(abs(real(V_ang)),[],1,'linear');
V_ang = V_ang*diag(1./(vmax.*sign(V_ang(vidx))));

for ii = 1:length(eigs_idx)
    bar(ax5{ii},real(V_ang(:,eigs_idx(ii))));
    axis(ax5{ii},[0,17,-1,1]);
    ylabel(ax5{ii},['eig',num2str(ii)]);
end

xlabel(ax5{end},'Generator number');

H5 = {'k','v1','v2','v3','v4','v5'};
M5 = [1:1:size(V_ang,1); real(V_ang(:,eigs_idx)).'];

% gen | v1 | v2 | etc.
fid5 = fopen(fig5_name,'w');
fprintf(fid5,'%s,%s,%s,%s,%s,%s\n',H5{:});     % must match number of columns
fprintf(fid5,'%6e,%6e,%6e,%6e,%6e,%6e\n',M5);  % must match number of columns
fclose(fid5);

%%
% 16m3tstsp: 16-machine system with a three ties between areas 4 and 5

clear all; close all; clc;     % reset workspace
load('16m3tstsp.mat');         % state-space model

%-------------------------------------%
% figs 

fig6_name = './dat/ch5_fig6.dat';

fig6 = figure;
for ii = 1:5
    ax6{ii} = subplot(5,1,ii,'parent',fig6);
    hold(ax6{ii},'on');
end

[V,D] = eig(a_mat);
ang_mask = (mac_state(:,2) == 1);  % rotor angle state index
eigs_idx = [105,73,71,69,67];      % eigenvalues of interest
V_ang = V(ang_mask,:);

% normalizing the rotor angle eigenvectors
[vmax,vidx] = max(abs(real(V_ang)),[],1,'linear');
V_ang = V_ang*diag(1./(vmax.*sign(V_ang(vidx))));

for ii = 1:numel(ax6)
    bar(ax6{ii},real(V_ang(:,eigs_idx(ii))));
    axis(ax6{ii},[0,17,-1,1]);
    ylabel(ax6{ii},['eig',num2str(ii)]);
end

xlabel(ax6{end},'Generator number');

H6 = {'k','v1','v2','v3','v4','v5'};
M6 = [1:1:size(V_ang,1); real(V_ang(:,eigs_idx)).'];

% gen | v1 | v2 | etc.
fid6 = fopen(fig6_name,'w');
fprintf(fid6,'%s,%s,%s,%s,%s,%s\n',H6{:});     % must match number of columns
fprintf(fid6,'%6e,%6e,%6e,%6e,%6e,%6e\n',M6);  % must match number of columns
fclose(fid6);

%%
% 16m2ttran -- time-domain simulation

clear all; close all; clc;         % reset workspace
load('16m2ttran.mat');             % data file

Fs = 30;                           % sample rate
tt = [t(1):1/60:2,2:1/Fs:t(end)];  % time vector

%-------------------------------------%
% fig 7

fig7_name = './dat/ch5_fig7.dat';

n_mac = size(mac_spd,1);
[xg,yg] = meshgrid(t,size(mac_spd,1):-1:1);
mesh(xg,yg,flipud(mac_spd),'faceColor','flat');
colormap jet

xlabel('Time (s)');
ylabel('Generator number');
zlabel('Speed (pu)');

% exporting data file
mac_spd_dec = interp1(t,flipud(mac_spd).',tt).';  % downsampling
mac_spd_dec = fliplr(mac_spd_dec)-1;
[xg_dec,yg_dec] = meshgrid(fliplr(tt),size(mac_spd_dec,1):-1:1);

[mrow,ncol] = size(xg_dec);
xg_vec = reshape(xg_dec,mrow*ncol,1);
yg_vec = reshape(yg_dec,mrow*ncol,1);
zg_vec = reshape(mac_spd_dec,mrow*ncol,1);

M = [xg_vec.'; yg_vec.'; zg_vec.'];

% break the data into overlapping parts
n_parts = 20;
ii_beg = [1,floor(ncol*(1:1:n_parts-1)/n_parts)];
ii_end = [floor(ncol*(1:1:n_parts-1)/n_parts),ncol];
for jj = 1:length(ii_beg)
    hh = {'xc','yc','zc'};
    fid = fopen([fig7_name(1:end-4),'part',num2str(jj),'.dat'],'w');
    fprintf(fid,'%s,%s,%s\n\n',hh{:});   % must match number of columns
    for ii = ii_beg(jj):ii_end(jj)
        fprintf(fid,'%6e,%6e,%6e\n',M(:,(ii-1)*mrow+1:ii*mrow));
        fprintf(fid,'\n');               % empty line required for pgfplots
    end
    fclose(fid);
end

%%
% fig 8

clear all; close all; clc;     % reset workspace
load('16m2ttran.mat');         % data file

Fs = 15;                       % sample rate
tt = t(1):1/Fs:t(end);         % time vector with constant step size

fig8_name = './dat/ch5_fig8.dat';

fig8 = figure;
ax81 = subplot(1,1,1,'parent',fig8);
hold(ax81,'on');

ang_idx = 1:9;
bus_idx = [2:8,10:29,53:61];

plot(ax81,t,mac_ang(ang_idx,:),t,unwrap(angle(bus_v(bus_idx,:)),[],2));
xlabel(ax81,'Time (s)');
ylabel(ax81,'Angle (rad)');
% legend(ax81,'gen 1','bus 23','location','southEast');

% exporting data file
mac_ang_dec = interp1(t,mac_ang.',tt).';
bus_ang_dec = interp1(t,unwrap(angle(bus_v),[],2).',tt).';

H8 = {'t'};
M8 = [tt];
s_str = '%s,';
e_str = '%e,';
for ii = 1:length(ang_idx)
    H8 = [H8, ['a',num2str(ii)]];
    M8 = [M8; mac_ang_dec(ang_idx(ii),:)];
    s_str = [s_str, '%s,'];
    e_str = [e_str, '%6e,'];
end

for ii = 1:length(bus_idx)
    H8 = [H8, ['b',num2str(ii)]];
    M8 = [M8; bus_ang_dec(bus_idx(ii),:)];
    s_str = [s_str, '%s,'];
    e_str = [e_str, '%6e,'];
end

fid8 = fopen(fig8_name,'w');
fprintf(fid8,[s_str(1:end-1),'\n'],H8{:});  % must match number of columns
fprintf(fid8,[e_str(1:end-1),'\n'],M8);     % must match number of columns
fclose(fid8);

%%
% cleaning up

clear all; close all; clc;

fprintf('\n  All done!\n\n');

% eof