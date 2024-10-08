function [im,dsat] = plotds(isat);
for k = 1:1001;
    im(k) = k*isat/100;
    dsat(k) = dessat(im(k),isat);
end
plot(im,dsat);
title('describing function for saturation')
xlabel('current/isat')
ylabel('effective gain')
