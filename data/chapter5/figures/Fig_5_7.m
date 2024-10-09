% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 5.7

% 16m2ttran.mat: 16-machine system with a two ties between areas 4 and 5

clear all; close all; clc;                    % reset workspace
load('../mat/16m2ttran.mat');                 % data file

Fs = 30;                                      % sample rate
tt = [t(1):1/60:2,2:1/Fs:t(end)];             % time vector

%-------------------------------------%
% fig 7

fig7_name = './csv/ch5_fig7.csv';

n_mac = size(mac_spd,1);
[xg,yg] = meshgrid(t,size(mac_spd,1):-1:1);
mesh(xg,yg,flipud(mac_spd),'faceColor','flat');
colormap jet

xlabel('Time (s)');
ylabel('Generator number');
zlabel('Speed (pu)');

% exporting data file
mac_spd_dec = interp1(t,flipud(mac_spd).',tt).';
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
    fid = fopen([fig7_name(1:end-4),'part',num2str(jj),'.csv'],'w');
    fprintf(fid,'%s,%s,%s\n\n',hh{:});
    for ii = ii_beg(jj):ii_end(jj)
        fprintf(fid,'%6e,%6e,%6e\n',M(:,(ii-1)*mrow+1:ii*mrow));
        fprintf(fid,'\n');                    % empty line required for pgfplots
    end
    fclose(fid);
end

% eof
