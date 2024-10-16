function [rs,xs,Xm,rr,xr,rr2,xr2,nll,VoltAmp,tfl,isfl,flpf,fleff,tst,ist,eflag]=calcdc(vr,flc,fleff,flpf,flslip,stt,stc,nll,dr,isat);
% syntax: [rs,xs,Xm,rr,xr,VoltAmp,tfl,tnl,tst,ist,emat]=calcdc(vr,flc,fleff,flpf,flslip,stc,nll,isat);
% Determines the equivalent circuit parameters of single cage induction
% motor models from the full load data
%Note: With a single cage, or wound rotor model, it is not possible to set
%      the parameters to obtain starting torque ratio of full load torque
% Input:
%   		vr		-	Rated Voltage KV
%           flc     -   full load current KA
%           fleff   -   full load efficiency percentage          
%           flpf    -   full load power factor
%           flslip  -   fractional slip at full load - rated voltage
%           stt     -   starting torque as a fraction of full load torque
%           stc     -   starting current as a ratio of full load current
%           nll     -   no load losses PU - if zero calculated by program
%           dr      -   design ratio - if zero set to 1
%           isat    -   ratio of rated current at which leakage reactances
%                       saturate - default 10
% 
% Output: Equivalent circuit parameters (pu on motor MVA base)
%           rs      -   stator resistance 
%           xs      -   stator leakage reactance
%           Xm      -   magnetizing reactance
%           rr1     -   first rotor cage resistance
%           xr     -    first rotor cage leakage reactance
%         VoltAmp	-	MVA base for parameters
%			tfl		-	Full load torque pu
%			tst		-	Starting torque pu
%			ist		-	Starting current pu
%			eflag	-	1 if solution not converged
%			
% Note: pu base power = sqrt(3)*vr*flc

% January 6, 2003
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2003 - All Rights Reserved
rs=[];xs=[];Xm=[];rr=[];xr=[];rr2 = []; xr2 = [];VoltAmp=[];tfl=[];isfl = [];tst=[];ist=[];eflag=0;
VoltAmp = sqrt(3)*vr*flc;
if nargin<7
    uiwait(msgbox('you must supply the first 7 input parameters','calc double cage error','modal'))
    eflag = 1;
    return
elseif nargin ==7
    dr = 1;
    nll=0;
    isat = 10;
elseif nargin==8
    dr = 1;
    isat = 10;
elseif nargin==9
	isat = 10;
end
pout = fleff*flpf;
if nll==0
    nll = (flpf-pout)/4;
end
tfl = pout/(1-flslip);
f = fleff/(1-flslip);
rre =flslip*f/flpf;% equivalent rotor resistance at full load
rs = flpf*(1-fleff/(1-flslip));
if rs<0
    uiwait(msgbox('rs negative - check no load loss','calcdc error','modal'));
    eflag = 1;
    return
end
sphi = sqrt(1-flpf*flpf);
flc = flpf-nll - i*sphi;
angfl = angle(flc);
Xm = f/sphi;
rrs1 =rre*stt*flpf*flpf/stc/stc/flslip;% equivalent rotor resistance at s=1
rrat = (rrs1/rre -1)*(1+dr*dr)/(1 - rrs1*flslip*flslip*dr*dr*(1+dr*dr)/rre);
rp = rre/(1+flslip*flslip*dr*dr*rrat);
rr = rp*(1+rrat);% first rotor cage resistance
if rr<0
    uiwait(msgbox('rr negative - try increasing the design ratio','caldc warning','modal'))
end
rr2 = rr/rrat;% second rotor cage resitance
xr2 = (rr+rr2)*dr;% from definition of design ratio
xsp2 = (1/stc/stc)-(rrs1+rs)^2;
if xsp2<0
    uiwait(msgbox('starting current too high','calcdc error','modal'))
    eflag = 1;
    return
end
xsp = sqrt(xsp2);
% assume xs and xr are equal
b = Xm - xsp/2; a = Xm*Xm+xsp*xsp/4;% xsp = xs + xsXm/(xs+Xm)
xs = sqrt(a)-b;xr=xs;
J = zeros(5);
x=zeros(5,1);y=x;
n_c1 = 0;
[zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdc(rs,xs,Xm,xr,xr2,rr,rr2,1,flslip,isat);
tfl = ir1*ir1*rre/flslip;
is = 1/(zr+i*zi);
[zrs,zis,xss,xrs,rrse,xrse,is1s,ir1s,eflag]=zdc(rs,xs,Xm,xr,xr2,rr,rr2,1,1,isat);
tst = ir1s*ir1s*rrse;
ist = 1/(zrs+i*zis);aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
x(1) = rr/flslip;x(2)=Xm;x(3)=xs;x(4)=rs;x(5) = rr2/flslip;xr2 = (rr+rr2)*dr;
y(1) = (1 - (nll+is*conj(is)*rs+ir1*ir1*rre)/flpf)-fleff;% error in efficiency
y(2) = abs(is) - abs(flc);% error in stator current magnitude
y(3) = angle(is) - angfl;
aist = angle(ist);stcn = abs(stc*exp(i*aist)-nll);
y(4) = stcn/abs(ist) - 1;% starting current error
y(5) = tst/tfl/stt - 1;% starting torque error
while (max(abs(y))>1e-12)&n_c1<50
    n_c1=n_c1+1;
    [y,Jc] = jacmdc(x,fleff,flpf,stc,stt,flc,flslip,nll,dr,isat);
    dx = Jc\y;
    x = x-dx;
    if (abs(max(x))>300)|(sum(isnan(x))~=0)|(sum(isinf(x))~=0)
        uiwait(msgbox('parameter values out-of-range','calcdc error','modal'))
        eflag = 1;
        return
    end
    rr = x(1)*flslip;Xm = x(2);xs = x(3);xr = x(3);rs = x(4);rr2 = x(5)*flslip;xr2 = (rr+rr2)*dr;
end
[zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdc(rs,xs,Xm,xr,xr2,rr,rr2,1,flslip,isat);
tfl = ir1*ir1*rre/flslip;
is = 1/(zr+i*zi);
[zrs,zis,xss,xrs,rrse,xrse,is1s,ir1s,eflag]=zdc(rs,xs,Xm,xr,xr2,rr,rr2,1,1,isat);
tst = ir1s*ir1s*rrse;
ist = abs(nll+1/(zrs+i*zis));
isfl = abs(is+nll);
afl = angle(is+nll);
flpf = cos(afl);
fleff = (1 - (nll+is*conj(is)*rs+ir1*ir1*rre)/flpf);
if n_c1 ==50
    uiwait(msgbox('solution not converged','caldc error','modal'))
    eflag = 1;
end


