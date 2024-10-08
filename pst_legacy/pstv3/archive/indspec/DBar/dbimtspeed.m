function [t,p,q,pfact,rre,xre,is,s,tfl,is1]=dbimtspeed(V,rs,xs,Xm,rr,xr,dbf,nll,isat,sfl,nplt)
% calculates induction motor steady state torque speed characteristics as a function of slip
% inputs
% V     -   motor voltage magnitude in PU on motor base
% rs    -   stator resistance in PU on motor base
% xs    -   stator leakage reactance in PU on motor base
% rr    -   rotor resistance in PU on motor base at zero slip
% xr    -   rotor leakage reactance in PU on motor base
% dbf   -   deep bar factor
% nll   -   no load loss
% isat  -   the current at which leakage inductance saturation starts
% sfl   -   the full load slip ( if non zero or not entered plots t/tfl and is/isfl)
% nplt = 1, for no plot
% outputs
% t     -   torque pu
% p     -   active power pu
% q     -   reactive power pu
% pfact -   power factor
% rre   -   effective rotor resitsnce pu
% xre   -   effective rotor leakage reactance pu
% is    -   stator current pu
% s     -   motor speed pu
% tfl   -   full load torque pu
% ifl   -   full load current
% December 6, 2002
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2002 - All Rights Reserved

for ns = 1001:-1:2
    s(ns) = 0.001*(ns-1);
    [zr,zi,xss,xrs,rre(ns),xre(ns),is1,ir1]=zdb(rs,xs,Xm,xr,rr,dbf,V,s(ns),isat);
    t(ns) = ir1*ir1*rre(ns)/s(ns);
    is(ns) = V*(nll+1/(zr+i*zi));
    p(ns) = V*real(is(ns));q(ns) = -V*imag(is(ns));
    pfact(ns) = p(ns)/abs(p(ns)+i*q(ns));
end
is = abs(is);
s=1-s;
switch nargin
case 9
    sfl=0;
	is1 = 1;
	tfl = 1;
	tlab = 'torque pu and power factor';
	ilab = 'p,q and i pu';
    nplt = 0;
case 10
    if sfl == 0
        is1 = 1;
	    tfl = 1;
	    tlab = 'torque pu and power factor';
	    ilab = 'p,q and i pu';
    else
        [zr,zi,xss,xrs,rre,xre,is1,ir1]=zdb(rs,xs,Xm,xr,rr,dbf,V,sfl,isat);
        is1 = abs(nll+1/(zr+i*zi));
	    tfl = ir1*ir1*rre/sfl;
	    tlab = 'torque/torque full load and power factor';
	    ilab = 'p and q pu, and i/i full load';
    end
    nplt = 0;
case 11
	if sfl == 0
        is1 = 1;
	    tfl = 1;
	    tlab = 'torque pu and power factor';
	    ilab = 'p,q and i pu';
    else
        [zr,zi,xss,xrs,rre,xre,is1,ir1]=zdb(rs,xs,Xm,xr,rr,dbf,V,sfl,isat);
        is1 = abs(nll+1/(zr+i*zi));
	    tfl = ir1*ir1*rre/sfl;
	    tlab = 'torque/torque full load and power factor';
	    ilab = 'p and q pu, and i/i full load';
    end
end
if ~nplt
	figure
	[AX,H1,H2]=plotyy(s,[t/tfl;pfact],s,[p;q;is/is1]);hold
	xlabel('speed pu');
	set(get(AX(1),'Ylabel'),'String',tlab)
	set(get(AX(2),'Ylabel'),'String',ilab)
    set(AX(1),'YLim',[0 ceil(max(t/tfl))])
    set(AX(2),'YLim',[0 ceil(max(is/is1))])
	title('induction motor steady state speed charateristics');
	legend(AX(1),{'torque' 'power factor'},2);legend(AX(2),{'power' 'reactive power' 'current'},1)
end