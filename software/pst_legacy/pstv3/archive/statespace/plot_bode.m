function p = plot_bode(f,ym,ya,col,uw)
% plots a bode diagram
% if uw ~=0, unwraps phase
p=1;
switch nargin
case 3
   col = 'k';uw = 0;
case 4
    uw = 0;
end
if uw ==0
    subplot(2,1,1);semilogx(f,20*log10(ym),col);subplot(2,1,2);semilogx(f,ya,col);
else
    ya1 = unwrap(pi*ya/180)*180/pi;
    subplot(2,1,1);semilogx(f,20*log10(ym),col);subplot(2,1,2);semilogx(f,ya1,col);
end
bode_lab;
return