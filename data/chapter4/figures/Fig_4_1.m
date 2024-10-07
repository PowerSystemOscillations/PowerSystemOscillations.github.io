% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

%% fig 4.1

% sbstsp.mat: state-space model for d2asb.m

clear all; close all; clc;                    % reset workspace
load('../mat/sbstsp.mat');                    % state-space model

%-------------------------------------%
% fig 1

fig1_name = './csv/ch4_figs1_2_3.csv';

fig1 = figure;
ax11 = subplot(1,1,1,'parent',fig1);
hold(ax11,'on');

for ii = 1:size(rlexcgen1,2)
    plot(ax11,real(rlexcgen1(:,ii)),imag(rlexcgen1(:,ii)),...
         'bd','markerFaceColor','b','markerSize',3.5);
end

for ii = 1:size(rlexcgen1,2)
    if (ii == 1001)
        plot(ax11,real(rlexcgen1(:,ii)),imag(rlexcgen1(:,ii)),...
             'ro');
    elseif (ii == 11)
        % plot(ax11,real(rlexcgen1(:,ii)),imag(rlexcgen1(:,ii)),...
        %     'rs','markerSize',8.5);
    end
end

plot(ax11,real(rlexcgen1(:,1)),imag(rlexcgen1(:,1)),'r+','lineWidth',0.75);

xlabel(ax11,'real (1/s)');
ylabel(ax11,'imaginary (rad/s)');
axis(ax11,[-200,10,-0.1,50]);

rl_vec = reshape(rlexcgen1,[1,numel(rlexcgen1)]);

H1 = {'k','mag','ang','re','im'};
M1 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid1 = fopen(fig1_name,'w');
fprintf(fid1,'%s,%s,%s,%s,%s\n',H1{:});
fprintf(fid1,'%6e,%6e,%6e,%6e,%6e\n',M1);
fclose(fid1);

part2_mask = logical(real(rl_vec) < 10 & real(rl_vec) > -90 ...
                     & imag(rl_vec) < 1.5 & imag(rl_vec) > -1.5);
part1_mask = ~part2_mask;

H1p1 = {'k','mag','ang','re','im'};
M1p1 = [1:length(rl_vec(part1_mask)); ...
        abs(rl_vec(part1_mask)); (180/pi)*angle(rl_vec(part1_mask)); ...
        real(rl_vec(part1_mask)); imag(rl_vec(part1_mask))];

fid1p1 = fopen([fig1_name(1:end-4),'part1.csv'],'w');
fprintf(fid1p1,'%s,%s,%s,%s,%s\n',H1p1{:});
fprintf(fid1p1,'%6e,%6e,%6e,%6e,%6e\n',M1p1);
fclose(fid1p1);

% decimating
rl_vec2 = reshape(rlexcgen1(1:10:end),[1,numel(rlexcgen1(1:10:end))]);

part2_mask = logical(real(rl_vec2) < 10 & real(rl_vec2) > -90 ...
                     & imag(rl_vec2) < 1.5 & imag(rl_vec2) > -1.5);

H1p2 = {'k','mag','ang','re','im'};
M1p2 = [1:length(rl_vec2(part2_mask)); ...
        abs(rl_vec2(part2_mask)); (180/pi)*angle(rl_vec2(part2_mask)); ...
        real(rl_vec2(part2_mask)); imag(rl_vec2(part2_mask))];

fid1p2 = fopen([fig1_name(1:end-4),'part2.csv'],'w');
fprintf(fid1p2,'%s,%s,%s,%s,%s\n',H1p2{:});
fprintf(fid1p2,'%6e,%6e,%6e,%6e,%6e\n',M1p2);
fclose(fid1p2);

% eof
