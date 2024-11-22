% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.11

clear all; close all; clc;

%-------------------------------------%
% fig 11(a)

fig11 = figure;
ax111 = subplot(2,1,1,'parent',fig11);
ax112 = subplot(2,1,2,'parent',fig11);
hold(ax111,'on');
hold(ax112,'on');
grid(ax111,'on');
grid(ax112,'on');

% d2asbegp_sweep_base_p4pu.mat: eigenvalues of the base case (no IBRs)
s = load(['../mat/d2asbegp_sweep_base_p4pu.mat']);

mask = (imag(s.l) > 0.001);
plot(ax111,real(s.l(mask)),imag(s.l(mask)),'b+','linewidth',1);

plot_track{1} = [real(s.l(mask)),imag(s.l(mask))];

case_vec = {'1ibr','2ibr'};
spec_vec = {'rx','mpentagram','cd'};
for ii = 1:numel(case_vec)
    base_case = case_vec{ii};

    % grid-following cases (reec)
    load(['../mat/d2asbegp_sweep_reec_p4pu_',base_case,'.mat']);

    l = sweep_track(1).l;
    mask = (imag(l) > 0.001);
    plot(ax111,real(l(mask)),imag(l(mask)),spec_vec{ii},'linewidth',1);

    plot_track{1+ii} = [real(l(mask)),imag(l(mask))];
end

ylabel(ax111,'Imag (rad/s)');

v = axis(ax111);
axis(ax111,[-3,1,0,8]);
legend(ax111,{'base','1 reec','2 reec'},'location','best');

H11a = {'re0','im0','re1','im1','re2','im2'};
M11a = -100*ones(6,16);
for ii = 1:numel(plot_track)
    M11a(2*ii-1:2*ii,1:length(plot_track{ii})) = plot_track{ii}.';
end

fig11a_name = './csv/ch15_fig11a.csv';
fid11a = fopen(fig11a_name,'w');
fprintf(fid11a,'%s,%s,%s,%s,%s,%s\n',H11a{:});
fprintf(fid11a,'%6e,%6e,%6e,%6e,%6e,%6e\n',M11a);
fclose(fid11a);

%-------------------------------------%
% fig 11(b)

% d2asbegp_sweep_base_p4pu.mat: eigenvalues of the base case
s = load(['../mat/d2asbegp_sweep_base_p4pu.mat']);

mask = (imag(s.l) > 0.001);
plot(ax112,real(s.l(mask)),imag(s.l(mask)),'b+','linewidth',1);

plot_track{1} = [real(s.l(mask)),imag(s.l(mask))];

case_vec = {'1ibr','2ibr','3ibr'};
spec_vec = {'rx','mpentagram','g^'};
for ii = 1:numel(case_vec)
    base_case = case_vec{ii};

    % grid-forming cases (gfma)
    load(['../mat/d2asbegp_sweep_gfma_p4pu_',base_case,'.mat']);

    l = sweep_track(1).l;
    mask = (imag(l) > 0.001);
    plot(ax112,real(l(mask)),imag(l(mask)),spec_vec{ii},'linewidth',1);

    plot_track{1+ii} = [real(l(mask)),imag(l(mask))];
end

ylabel(ax112,'Imag (rad/s)');
xlabel(ax112,'Real (1/s)');

v = axis(ax112);
axis(ax112,[-3,1,0,8]);
legend(ax112,{'base','1 gfma','2 gfma','3 gfma'},'location','best');

H11b = {'re0','im0','re1','im1','re2','im2','re3','im3'};
M11b = -100*ones(8,16);
for ii = 1:numel(plot_track)
    M11b(2*ii-1:2*ii,1:length(plot_track{ii})) = plot_track{ii}.';
end

fig11b_name = './csv/ch15_fig11b.csv';
fid11b = fopen(fig11b_name,'w');
fprintf(fid11b,'%s,%s,%s,%s,%s,%s,%s,%s\n',H11b{:});
fprintf(fid11b,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M11b);
fclose(fid11b);

% eof
