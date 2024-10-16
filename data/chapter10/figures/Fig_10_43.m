%% fig 10.43

clear all; close all; clc;
load('d2aphvdcss.mat');

fig43_name = './dat/ch10_fig43.dat';

fig43 = figure;
ax431 = subplot(1,1,1,'parent',fig43);
hold(ax431,'on');
grid(ax431,'on');

sys_dcr = ss(a_mat,b_dcr(:,1),(c_ang(3,:)-c_ang(9,:)),(d_angdcr(3,:)-d_angdcr(9,:)));
rate = (2*pi*60)*tf([1 0],(2*pi*60)*[0.01 1]);

sys_dcr_rate = sys_dcr*rate;

K = [0:0.1:10,1e6];
eig_track = zeros(size(sys_dcr_rate.a,1),length(K));
for ii = 1:length(K)
    eig_track(:,ii) = eig(sys_dcr_rate.a - K(ii)*sys_dcr_rate.b*sys_dcr_rate.c);
    if ii < length(K)
        plot(ax431,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'bd','markerFaceColor','b','markerSize',3.5);
    end
end

for ii = 1:size(eig_track,2)
    if (ii == length(K))
        plot(ax431,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'ro');
    elseif (ii == 11)
        plot(ax431,real(eig_track(:,ii)),imag(eig_track(:,ii)),...
             'rs','markerSize',8.5);
    end
end

plot(ax431,real(eig_track(:,1)),imag(eig_track(:,1)),'r+','lineWidth',0.75);
plot(ax431,[-5,0],[5*tan(acos(0.05)),0],'k-');

axis(ax431,[-20,5,0,10]);
xlabel(ax431,'Real');
ylabel(ax431,'Imaginary (rad/s)');

rl_vec = reshape(eig_track,[1,numel(eig_track)]);

H43 = {'k','mag','ang','re','im'};
M43 = [1:length(rl_vec); abs(rl_vec); (180/pi)*angle(rl_vec);
      real(rl_vec); imag(rl_vec)];

fid43 = fopen(fig43_name,'w');
fprintf(fid43,'%s,%s,%s,%s,%s\n',H43{:});    % must match number of columns
fprintf(fid43,'%6e,%6e,%6e,%6e,%6e\n',M43);  % must match number of columns
fclose(fid43);

[V,d] = eig(sys_dcr_rate.a,'vector');
W = pinv(V).';                                        % left eigenvectors

fence = 1:1:length(d);
mask = (real(d) > -30) & (imag(d) > 1.5);
fence = fence(mask);

for ii = 1:length(fence)
    Ri(ii) = sys_dcr_rate.c*V(:,fence(ii))*W(:,fence(ii)).'*sys_dcr_rate.b;  % residue
end

ord = [2,3,4,5,1];    % display order
disp([d(fence(ord)),Ri(ord).']);

% eof
