% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 3.8

% emstsp.mat: state-space model for d2aem.m

clear all; close all; clc;
load('../mat/emstsp.mat');
fig8_name = './csv/ch3_fig8.csv';             % data file

fig8 = figure;                                % create figure table
ax81 = subplot(1,1,1,'parent',fig8);
hold(ax81,'on');                              % always on for axis object

A = a_mat;
A1=[]; A2=[]; InterA=[]; x=[];

for i = -1.0: 0.01: 0.0
    x(end+1) = i;
    A(2,2) = i;
    [V,D,W] = eig(A);

    Dia = diag(D);
    A1(end+1) = real(Dia(2));
    A2(end+1) = real(Dia(4));
    InterA(end+1) = real(Dia(6));
end

plot(ax81, x, A1, x, A2, x, InterA);

% axis labels
xlabel(ax81,'value of A(2,2)');
ylabel(ax81,'real part of electromechanical modes');

% ingraph legend
legend(ax81,{'area 1 local mode','area 2 local mode','inter-area mode'},'location','best');

H8 = {'a22','rp1','ip1','rp2','ip2','rp3','ip3'};
M8 = [x; real(A1); imag(A1); real(A2); imag(A2); real(InterA); imag(InterA)];

fid8 = fopen(fig8_name,'w');
fprintf(fid8,'%s,%s,%s,%s,%s,%s,%s\n',H8{:});
fprintf(fid8,'%6e,%6e,%6e,%6e,%6e,%6e,%6e\n',M8);
fclose(fid8);

% eof
