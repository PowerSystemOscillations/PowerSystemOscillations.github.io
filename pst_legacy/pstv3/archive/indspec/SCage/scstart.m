function [x,t] = scstart(V,f,tlst,tlspd,rs,xs,Xm,rr,xr,isat,H); 
% calculates the starting characteristics of a single cage induction motor
global V f xs xr Xm rr rs H tlst tlspd isat
s=1;
k=1;
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,V,s,isat);
w=2*pi*f;
h = 0.01/w;
Ls = (xss+Xm)/w;Lr = (xrs+Xm)/w;
M = Xm/w;
Lsp = Ls-M*M/Lr;
as = rs/Lsp;asr = as*M/Lr;
Lrp = Lr-M*M/Ls;
ar = rr/Lrp;ars =ar*M/Ls;
tcoef = Xm/(Lr*Ls-M*M);
isc = 1/(zr+i*zi);
irc = isc*i*Xm/(rr+i*(xrs+Xm));
lmat = [Ls 0 M 0;0 Ls 0 M;M 0 Lr 0;0 M 0 Lr];
psi = lmat*[real(isc);imag(isc);real(irc);imag(irc)];
