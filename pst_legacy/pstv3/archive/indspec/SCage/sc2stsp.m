function [select,is,ir,telec,psi] = sc2stsp(V,s,f,rs,xs,Xm,rr,xr,isat);
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,V,s,isat);
w=2*pi*f;
Xr = xrs+Xm;Xs = xss+Xm;
Xsp = xss+xrs*Xm/(xrs+Xm);
Xrp = xrs+xss*Xm/(xss+Xm);
as = rs/Xsp;asr = as*Xm/Xr;
ar = rr/Xrp;ars = ar*Xm/Xs;
tcoef = Xm/Xsp;
is = 1/(zr+i*zi);
if s~=0;
    ir = is*i*Xm/(rr/s+i*(xrs+Xm));
else
    ir = 0;
end
Xmat = [xss+Xm  0  Xm 0;0 xss+Xm 0 Xm; Xm 0 xrs+Xm 0;0 Xm 0 xrs+Xm];
IXmat = [xrs+Xm 0 -Xm 0;0 xrs+Xm 0 -Xm;-Xm 0 xss+Xm 0;0 -Xm 0 xss+Xm]/(Xs*Xr-Xm*Xm);
psi = Xmat*[real(is);imag(is);real(ir);imag(ir)];
asmat = zeros(4);bs = zeros(4,1);cs = zeros(5,4);ds = zeros(5,1);
asmat = [-as 1 asr 0 ;-1 -as  0 asr ;ars  0 -ar  s ; 0 ars -s -ar];
bs = [0;V;0;0];
cs(1:4,:) = IXmat;% currents
cs(5,:) = (Xm/(Xr*Xs-Xm*Xm))*[-psi(4) psi(3) -psi(1) psi(2)];%change in torque
telec = (psi(3)*psi(2) - psi(4)*psi(1))*(Xm/(Xr*Xs-Xm*Xm));
select = stsp(asmat,bs,cs,ds);