function [rs,xs,Xm,rr,xr,nll,VoltAmp,tfl,isfl,flpf,fleff,tst,ist,eflag]=calcsc(vr,flc,fleff,flpf,flslip,stc,nll,isat);
% syntax: [rs,xs,Xm,rr,xr,VoltAmp,tfl,tnl,tst,ist,emat]=calcdc(vr,flc,fleff,flpf,flslip,stc,nll,isat);
% Determines the equivalent circuit parameters of single cage induction
% motor models from the full load data
%Note: With a single cage, or wound rotor model, it is not possible to set
%      the parameters to obtain starting torque ratio of full load torque
% Input:
%           vr      -   Rated Voltage KV
%           flc     -   full load current KA
%           fleff   -   full load efficiency percentage          
%           flpf    -   full load power factor
%           flslip  -   fractional slip at full load - rated voltage
%           stc     -   starting current as a fraction of full load current
%           nll     -   no load losses PU - if zero calculated by program
%           isat    -   ratio of rated current at which leakage reactances
%                       saturate - default 10
% Output: Equivalent circuit parameters (pu on motor MVA base)
%           rs      -   stator resistance 
%           xs      -   stator leakage reactance
%           Xm      -   magnetizing reactance
%           rr1     -   first rotor cage resistance
%           xr     -    first rotor cage leakage reactance
%         VoltAmp	-	VoltAmp base for parameters
%			tfl		-	Full load torque pu
%			tst		-	Starting torque pu
%			ist		-	Starting current pu
%			eflag	-	1 if solution not converged
%			
% Note: pu base power = sqrt(3)*vr*flc

% December 10, 2002
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2002 - All Rights Reserved

rs=[];xs=[];Xm=[];rr=[];xr=[];VoltAmp=[];tfl=[];tst=[];ist=[];eflag=0;
VoltAmp = sqrt(3)*vr*flc;
if nargin<6
    uiwait(msgbox('you must supply the first 6 input parameters','calc double cage error','modal'))
    eflag = 1;
    return
elseif nargin ==6
    nll=0;
    isat = 10;
elseif nargin==7
    isat = 10;
end
pout = fleff*flpf;
if nll==0
    nll = (flpf-pout)/4;
end
tfl = pout/(1-flslip);
f = fleff/(1-flslip);
rr =flslip*f/flpf;
rs = flpf*(1-fleff/(1-flslip));
if rs<0
    uiwait(msgbox('rs negative - check no load loss','calcsc error','modal'));
    eflag = 1;
    return
end
sphi = sqrt(1-flpf*flpf);
flc = flpf-nll - i*sphi;
angfl = angle(flc);
Xm = f/sphi;
xsp2 = (1/stc/stc)-(rr+rs)^2;
if xsp2<0
    uiwait(msgbox('starting current too high','calcsc error','modal'))
    eflag = 1;
    return
end
xsp = sqrt(xsp2);
% assume xs and xr are equal
b = Xm - xsp/2; a = Xm*Xm+xsp*xsp/4;% xsp = xs + xsXm/(xs+Xm)
xs = sqrt(a)-b;xr=xs;
J = zeros(4);
x=zeros(4,1);y=x;
x(1) = rr/flslip;x(2)=Xm;x(3)=xs;x(4)=rs;
n_c1 = 0;
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
while (max(abs(y))>1e-12)&n_c1<50
    n_c1=n_c1+1;
    [y,Jc] = jacmot(x,fleff,flpf,stc,flc,flslip,nll,isat);
    dx = Jc\y;
    x = x-dx;
    rs = x(4);xs = x(3);xr=x(3);Xm=x(2);rr = x(1)*flslip;
end
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,flslip,isat);
is = 1/(zr+i*zi); ir = is*i*Xm/(rr/flslip +i*(xr+Xm));
tfl = ir*conj(ir)*rr/flslip;
[zrs,zis,xss,xrs,is1s,ir1s,eflag]=zsc(rs,xs,Xm,xr,rr,1,1,isat);
ist = 1/(zrs+i*zis);tst = ir1s*ir1s*rr;aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
isfl = abs(nll + is);
afl = angle(nll + is);
flpf = cos(afl);
fleff = tfl*(1-flslip)/flpf;
ist = abs(ist+nll);
tst = rr*ir1s*ir1s;
if n_c1 ==50
    uiwait(msgbox('solution not converged','calsc error','modal'))
    eflag = 1;
end


