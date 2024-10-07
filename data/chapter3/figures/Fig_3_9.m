% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.9

% emstsp.mat: state-space model for d2aem.m

clear all; close all; clc;
load('../mat/emstsp.mat');
fig9_name = './csv/ch3_fig9.csv';             % data file

fig9 = figure;                                % create figure table
ax91 = subplot(1,1,1,'parent',fig9);
hold(ax91,'on');                              % always on for axis object

x = -1:0.01:0;
modes.a1 = zeros(size(x));
modes.a2 = zeros(size(x));
modes.ia = zeros(size(x));

for ii = 1:length(x)
    A = a_mat;
    A(6,6) = x(ii);

    [V,D,~] = eig(A);
    dd = diag(D);

    modes.a1(ii) = dd(2);
    modes.a2(ii) = dd(4);
    modes.ia(ii) = dd(6);
end

plot(ax91, x, real(modes.a1), x, real(modes.a2), x, real(modes.ia));

% axis labels
xlabel(ax91,'value of A(6,6)');
ylabel(ax91,'real part of electromechanical modes');

% ingraph legend
legend(ax91,{'area 1 local mode','area 2 local mode','inter-area mode'},'location','best');

H9 = {'a66','rp1','ip1','rp2','ip2','rp3','ip3'};
M9 = [x; real(modes.a1); imag(modes.a1);
         real(modes.a2); imag(modes.a2);
         real(modes.ia); imag(modes.ia)];

fid9 = fopen(fig9_name,'w');
fprintf(fid9,'%s,%s,%s,%s,%s,%s,%s\n',H9{:});
fprintf(fid9,'%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M9);
fclose(fid9);

% eof
