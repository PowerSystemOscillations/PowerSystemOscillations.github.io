function [y,Jc] = jacmot(x,fleff,flpf,stc,flc,flslip,nll,isat);
y = zeros(4,1);Jc = zeros(4);
angfl = angle(flc);
rr = x(1)*flslip;Xm = x(2);xs = x(3);xr = xs;rs = x(4);
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,flslip,isat);
is = 1/(zr+i*zi); ir = is*i*Xm/(rr/flslip +i*(xr+Xm));
tfl = ir*conj(ir)*rr/flslip;
[zrs,zis,xss,xrs,is1s,ir1s,eflag]=zsc(rs,xs,Xm,xr,rr,1,1,isat);
ist = 1/(zrs+i*zis);tst = ir1s*ir1s*rr;aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
% errors
y(1) = (1-(nll+is*conj(is)*rs+ir*conj(ir)*rr)/flpf) -fleff;% full load efficiency error
y(2) = abs(is) - abs(flc); % full load current magnitide error
y(3) = angle(is) - angfl;% full load current angle error
y(4) = stcn/abs(ist) - 1;% starting current error
y1 = y;
rr = (x(1)+1e-5)*flslip;
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,flslip,isat);
is = 1/(zr+i*zi); ir = is*i*Xm/(rr/flslip +i*(xr+Xm));
tfl = ir*conj(ir)*rr/flslip;
[zrs,zis,xss,xrs,is1s,ir1s,eflag]=zsc(rs,xs,Xm,xr,rr,1,1,isat);
ist = 1/(zrs+i*zis);tst = ir1s*ir1s*rr;aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
% errors
y1(1) = (1-(nll+is*conj(is)*rs+ir*conj(ir)*rr)/flpf) -fleff;% full load efficiency error
y1(2) = abs(is) - abs(flc); % full load current magnitide error
y1(3) = angle(is) - angfl;% full load current angle error
y1(4) = stcn/abs(ist) - 1;% starting current error
Jc(:,1) = 1e5*(y1-y);
y2 = y;
rr = x(1)*flslip;Xm = x(2)+1e-5;xs = x(3);xr = xs;rs = x(4);
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,flslip,isat);
is = 1/(zr+i*zi); ir = is*i*Xm/(rr/flslip +i*(xr+Xm));
tfl = ir*conj(ir)*rr/flslip;
[zrs,zis,xss,xrs,is1s,ir1s,eflag]=zsc(rs,xs,Xm,xr,rr,1,1,isat);
ist = 1/(zrs+i*zis);tst = ir1s*ir1s*rr;aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
% errors
y2(1) = (1-(nll+is*conj(is)*rs+ir*conj(ir)*rr)/flpf) -fleff;% full load efficiency error
y2(2) = abs(is) - abs(flc); % full load current magnitide error
y2(3) = angle(is) - angfl;% full load current angle error
y2(4) = stcn/abs(ist) - 1;% starting current error
Jc(:,2) = 1e5*(y2-y);
y3 = y;
rr = x(1)*flslip;Xm = x(2);xs = x(3)+1e-6;xr = xs;rs = x(4);
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,flslip,isat);
is = 1/(zr+i*zi); ir = is*i*Xm/(rr/flslip +i*(xr+Xm));
tfl = ir*conj(ir)*rr/flslip;
[zrs,zis,xss,xrs,is1s,ir1s,eflag]=zsc(rs,xs,Xm,xr,rr,1,1,isat);
ist = 1/(zrs+i*zis);tst = ir1s*ir1s*rr;aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
% errors
y3(1) = (1-(nll+is*conj(is)*rs+ir*conj(ir)*rr)/flpf) -fleff;% full load efficiency error
y3(2) = abs(is) - abs(flc); % full load current magnitide error
y3(3) = angle(is) - angfl;% full load current angle error
y3(4) = stcn/abs(ist) - 1;% starting current error
Jc(:,3) = 1e6*(y3-y);
y4 = y;
rr = x(1)*flslip;Xm = x(2);xs = x(3);xr = xs;rs = x(4)+1e-6;
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,flslip,isat);
is = 1/(zr+i*zi); ir = is*i*Xm/(rr/flslip +i*(xr+Xm));
tfl = ir*conj(ir)*rr/flslip;
[zrs,zis,xss,xrs,is1s,ir1s,eflag]=zsc(rs,xs,Xm,xr,rr,1,1,isat);
ist = 1/(zrs+i*zis);tst = ir1s*ir1s*rr;aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
% errors
y4(1) = (1-(nll+is*conj(is)*rs+ir*conj(ir)*rr)/flpf) -fleff;% full load efficiency error
y4(2) = abs(is) - abs(flc); % full load current magnitide error
y4(3) = angle(is) - angfl;% full load current angle error
y4(4) = stcn/abs(ist) - 1;% starting current error
Jc(:,4) = 1e6*(y4-y);
return