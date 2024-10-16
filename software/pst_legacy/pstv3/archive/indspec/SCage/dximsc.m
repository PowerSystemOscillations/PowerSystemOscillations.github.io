function   dx = dximsc(t,x);
global V f xs xr Xm rr rs H tlst tlspd isat
dx = zeros(5,1);
w = 2*pi*f;
xerr =1;
xss = xs; xrs = xr;
while xerr>1e-3
    lmat = [xss+Xm 0 Xm 0;0 xss+Xm 0 Xm;Xm 0 xrs+Xm 0;0 Xm 0 xrs+Xm]/w;
    ivec = lmat\x(1:4);is = ivec(1)+i*ivec(2);ir = ivec(3)+i*ivec(4);
    xssn = xs*(1+dessat(abs(is),isat))/2;xrsn = xr*(1+dessat(abs(ir),isat))/2;
    xerr = max(abs([(xssn-xss)/xs (xrsn-xrs)/xr]));
    xss = xssn;xrs = xrsn;
end
Ls = (xss+Xm)/w;Lr = (xrs+Xm)/w;
M = Xm/w;
Lsp = Ls-M*M/Lr;
as = rs/Lsp;asr = as*M/Lr;
Lrp = Lr-M*M/Ls;
ar = rr/Lrp;ars =ar*M/Ls;
tcoef = Xm/(Lr*Ls-M*M);
s = x(5);
ao = -[as -w -asr 0;w as 0 -asr;-ars 0 ar -w*s;0 -ars w*s ar];
dx(1:4) = ao*x(1:4)+[0 V 0 0]';
dx(5) = (tlst*x(5)+tlspd*(1-x(5))*(1-x(5))-tcoef*(psi(2)*psi(3)-psi(1)*psi(4)))/2/H;