function [y,Jc] = jacmdb(x,fleff,flpf,stc,stt,flc,flslip,nll,isat);
y = zeros(5,1);J = zeros(5);
angfl = angle(flc);
rr = x(1)*flslip;Xm = x(2);xs = x(3);xr = x(3);rs = x(4);dbf = x(5);
[zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,flslip,isat);
tfl = ir1*ir1*rre/flslip;
is = 1/(zr+i*zi);
[zrs,zis,xss,xrs,rrse,xrse,is1s,ir1s,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,1,isat);
tst = ir1s*ir1s*rrse;
ist = 1/(zrs+i*zis);aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
% errors
y(1) = (1-(nll+is*conj(is)*rs+ir1*ir1*rre)/flpf) -fleff;% full load efficiency error
y(2) = abs(is) - abs(flc); % full load current magnitide error
y(3) = angle(is) - angfl;% full load current angle error
y(4) = stcn/abs(ist) - 1;% starting current error
y(5) = tst/tfl/stt -1;
y1 = y;Jc = J;
rr = (x(1)+1e-6)*flslip;
[zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,flslip,isat);
tfl = ir1*ir1*rre/flslip;
is = 1/(zr+i*zi);
[zrs,zis,xss,xrs,rrse,xrse,is1s,ir1s,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,1,isat);
tst = ir1s*ir1s*rrse;
ist1 = 1/(zrs+i*zis);aist = angle(ist1);stcn = abs(stc*exp(i*aist)-nll);
y1(1) = (1-(nll+is*conj(is)*rs+ir1*ir1*rre)/flpf) -fleff;% full load efficiency error
y1(2) = abs(is) - abs(flc); % full load current magnitide error
y1(3) = angle(is) - angfl;% full load current angle error
y1(4) = stcn/abs(ist1) - 1;% starting current error
y1(5) = tst/tfl/stt -1;
Jc(:,1) = 1e6*(y1-y);
rr = x(1)*flslip;Xm = x(2);xs = x(3);xr = x(3);rs = x(4);dbf = x(5);
y2 = y;
Xm = x(2)+1e-5;
[zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,flslip,isat);
tfl = ir1*ir1*rre/flslip;
is = 1/(zr+i*zi);
[zrs,zis,xss,xrs,rrse,xrse,is1s,ir1s,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,1,isat);
tst = ir1s*ir1s*rrse;
ist1 = 1/(zrs+i*zis);aist = angle(ist1);stcn = abs(stc*exp(i*aist)-nll);
y2(1) = (1-(nll+is*conj(is)*rs+ir1*ir1*rre)/flpf) -fleff;% full load efficiency error
y2(2) = abs(is) - abs(flc); % full load current magnitide error
y2(3) = angle(is) - angfl;% full load current angle error
y2(4) = stcn/abs(ist1) - 1;% starting current error
y2(5) = tst/tfl/stt -1;
Jc(:,2) = 1e5*(y2-y);
y3 = y;
rr = x(1)*flslip;Xm = x(2);xs = x(3);xr = x(3);rs = x(4);dbf = x(5);
xs = xs+1e-6;xr = xs;
[zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,flslip,isat);
tfl = ir1*ir1*rre/flslip;
is = 1/(zr+i*zi);
[zrs,zis,xss,xrs,rrse,xrse,is1s,ir1s,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,1,isat);
tst = ir1s*ir1s*rrse;
ist1 = 1/(zrs+i*zis);aist = angle(ist1);stcn = abs(stc*exp(i*aist)-nll);
y3(1) = (1-(nll+is*conj(is)*rs+ir1*ir1*rre)/flpf) -fleff;% full load efficiency error
y3(2) = abs(is) - abs(flc); % full load current magnitide error
y3(3) = angle(is) - angfl;% full load current angle error
y3(4) = stcn/abs(ist1) - 1;% starting current error
y3(5) = tst/tfl/stt -1;
Jc(:,3) = 1e6*(y3-y);
y4 = y;
rr = x(1)*flslip;Xm = x(2);xs = x(3);xr = x(3);rs = x(4);dbf = x(5);
rs = rs+1e-6;
[zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,flslip,isat);
tfl = ir1*ir1*rre/flslip;
is = 1/(zr+i*zi);
[zrs,zis,xss,xrs,rrse,xrse,is1s,ir1s,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,1,isat);
tst = ir1s*ir1s*rrse;
ist1 = 1/(zrs+i*zis);aist = angle(ist1);stcn = abs(stc*exp(i*aist)-nll);
y4(1) = (1-(nll+is*conj(is)*rs+ir1*ir1*rre)/flpf) -fleff;% full load efficiency error
y4(2) = abs(is) - abs(flc); % full load current magnitide error
y4(3) = angle(is) - angfl;% full load current angle error
y4(4) = stcn/abs(ist1) - 1;% starting current error
y4(5) = tst/tfl/stt -1;
Jc(:,4) = 1e6*(y4-y);
y5 = y;
rr = x(1)*flslip;Xm = x(2);xs = x(3);xr = x(3);rs = x(4);dbf = x(5);
dbf = (x(5)+1e-6);
[zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,flslip,isat);
tfl = ir1*ir1*rre/flslip;
is = 1/(zr+i*zi);
[zrs,zis,xss,xrs,rrse,xrse,is1s,ir1s,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,1,isat);
tst = ir1s*ir1s*rrse;
ist1 = 1/(zrs+i*zis);aist = angle(ist1);stcn = abs(stc*exp(i*aist)-nll);
y5(1) = (1-(nll+is*conj(is)*rs+ir1*ir1*rre)/flpf) -fleff;% full load efficiency error
y5(2) = abs(is) - abs(flc); % full load current magnitide error
y5(3) = angle(is) - angfl;% full load current angle error
y5(4) = stcn/abs(ist1) - 1;% starting current error
y5(5) = tst/tfl/stt -1;
Jc(:,5) = 1e6*(y5-y);
return