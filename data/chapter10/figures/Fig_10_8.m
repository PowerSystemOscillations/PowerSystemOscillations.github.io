% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 10.8

% d2adcem.mat:  2-area system, base case
% d2adcem1.mat: 2-area system, one line 3--101
% d2adcem2.mat: 2-area system, one line 13--101
% d2adcem3.mat: 2-area system, one line each 3--101, 13--101

clear all; close all; clc;

%-------------------------------------%
% fig 8

fig8_name = './csv/ch10_fig8.csv';

fig8 = figure;
ax81 = subplot(1,1,1,'parent',fig8);
hold(ax81,'on');
grid(ax81,'on');

fcase{1} = '../mat/d2adcem.mat';   % base case
fcase{2} = '../mat/d2adcem1.mat';  % one line 3--101
fcase{3} = '../mat/d2adcem2.mat';  % one line 13--101
fcase{4} = '../mat/d2adcem3.mat';  % one line each 3--101, 13--101

for ii = 1:numel(fcase)
    load(fcase{ii});

    sys = ss(a_mat,b_svc(:,1),c_ilmf(5,:),0);
    [pt{ii},zt{ii}] = pzmap(sys);

    % padding for size consistency
    pt{ii} = pt{ii}.';
    zt{ii} = [zt{ii}.',-10];

    plot(ax81,real(pt{ii}),imag(pt{ii}),'r+','lineWidth',0.75);
    plot(ax81,real(zt{ii}),imag(zt{ii}),'bo','lineWidth',0.75);
end

plot(ax81,[0,-5],[0,5*tan(acos(0.05))],'k');
axis(ax81,[-3,1,0,10]);

ylabel(ax81,'Imaginary (rad/s)');
xlabel(ax81,'Real');

H8 = {'k','rpb','ipb','rzb','izb','rp1','ip1','rz1','iz1', ...
          'rp2','ip2','rz2','iz2','rp3','ip3','rz3','iz3'};

M8 = [1:1:length(pt{1});
      real(pt{1}); imag(pt{1}); real(zt{1}); imag(zt{1});
      real(pt{2}); imag(pt{2}); real(zt{2}); imag(zt{2});
      real(pt{3}); imag(pt{3}); real(zt{3}); imag(zt{3});
      real(pt{4}); imag(pt{4}); real(zt{4}); imag(zt{4})];

fid8 = fopen(fig8_name,'w');
fprintf(fid8,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',H8{:});
fprintf(fid8,'%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M8);
fclose(fid8);

% eof
