% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 15.14

clear all; close all; clc;

%-------------------------------------%
% fig 14

fig14_name = './csv/ch15_fig14.csv';

fig14 = figure;
ax14 = subplot(1,1,1,'parent',fig14);
hold(ax14,'on');
grid(ax14,'on');

% d2asbegp_sweep_base_p4pu.mat: eigenvalues of the base case
s = load('../mat/d2asbegp_sweep_base_p4pu.mat');
mask = (imag(s.l) >= 0);
plot_reec_track{1} = [real(s.l(mask)),imag(s.l(mask))];
plot_gfma_track{1} = [real(s.l(mask)),imag(s.l(mask))];

% grid-following case (reec)
load('../mat/d2asbegp_sweep_reec_p4pu_bus91.mat');

for ii = 1:numel(sweep_track)
    l = sweep_track(ii).l;
    mask = (imag(l) > 0.001);
    p0 = plot(ax14,real(l(mask)),imag(l(mask)),'b*');

    plot_reec_track{1+ii} = [real(l(mask)),imag(l(mask))];
end

% grid-forming case (gfma)
load('../mat/d2asbegp_sweep_gfma_p4pu_bus91.mat')

for jj = 1:numel(sweep_track)
    l = sweep_track(jj).l;
    mask = (imag(l) > 0.001);
    p1 = plot(ax14,real(l(mask)),imag(l(mask)),'g*');

    plot_gfma_track{1+jj} = [real(l(mask)),imag(l(mask))];
end

% d2asbegp_sweep_base_p4pu.mat: eigenvalues of the base case
s = load('../mat/d2asbegp_sweep_base_p4pu.mat');

mask = (imag(s.l) >= 0);
plot(ax14,real(s.l(mask)),imag(s.l(mask)),'r+','linewidth',2);

xlabel('Real (1/s)');
ylabel('Imag (rad/s)');

v = axis(ax14);
axis(ax14,[-8.5,1,v(3),2*pi*3.25]);

legend(ax14,[p0,p1],{'reec','gfma'},'location','best');

reec_tmp = [];
for ii = 1:numel(plot_reec_track)
    reec_tmp = [reec_tmp; plot_reec_track{ii}];
end

gfma_tmp = [];
for ii = 1:numel(plot_gfma_track)
    gfma_tmp = [gfma_tmp; plot_gfma_track{ii}];
end

H14 = {'re_reec','im_reec','re_gfma','im_gfma'};
M14 = -100*ones(max(length(reec_tmp),length(gfma_tmp)),4);
M14(1:length(reec_tmp),1:2) = reec_tmp;
M14(1:length(gfma_tmp),3:4) = gfma_tmp;
M14 = M14.';

fid14 = fopen(fig14_name,'w');
fprintf(fid14,'%s,%s,%s,%s\n',H14{:});
fprintf(fid14,'%6e,%6e,%6e,%6e\n',M14);
fclose(fid14);

% eof
