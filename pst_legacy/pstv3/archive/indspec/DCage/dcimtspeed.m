function [t,p,q,pfact,rre,xre,is,s,tfl,is1]=dcimtspeed(V,rs,xs,Xm,rr1,xr1,rr2,xr2,nll,isat,sfl,nplt)
% calculates induction motor steady state torque speed characteristics as a function of slip
% Inputs
% V 	-	motor voltage magnitude in PU on motor base
% rs 	-	stator resistance in PU on motor base
% xs 	-	stator leakage reactance in PU on motor base
% rr1 	-	first cage rotor resistance in PU on motor base
% xr1 	-	first cage rotor leakage reactance in PU on motor base
% rr2 	-	second cage resistance in PU on motor base
% xr2 	-	inter cage reactance in PU on motor base
% nll   -   no load loss
% isat 	-	the current at which leakage inductance saturation starts
% sfl	-	full load slip 
% nplt =1 for no plot
% Note: 	if sfl not supplied or zero plots give unnormalized torque and current
% Outputs
% t		-	vector of torques pu
% p		-	vector of active powers pu
% q		-	vector of reactive powers pu
% is	-	vector of stator current pu
% s		-	vector of motor speed pu
% tfl   -   full load torque if full load slip specified, otherwise unity
% is1   =   full load current if full load slip specified, otherwise unity
% December 6, 2002
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2002 - All Rights Reserved

for ns = 1001:-1:2
    s(ns) = 0.001*(ns-1);
    [zr,zi,xss,xrs,rre(ns),xre(ns),is1,ir1]=zdc(rs,xs,Xm,xr1,xr2,rr1,rr2,V,s(ns),isat);
    t(ns) = ir1*ir1*rre(ns)/s(ns);
    is(ns) = V*(nll+1/(zr+i*zi));
    p(ns) = V*real(is(ns));q(ns) = -V*imag(is(ns)); 
    pfact(ns) = p(ns)/abs(p(ns)+i*q(ns));
end

s=1-s;
is = abs(is);
switch nargin
case 10
	is1 = 1;
	tfl = 1;
	tlab = 'torque pu and power factor';
	ilab = 'p,q and i pu';
    nplt = 0;
case 11
    if sfl ==0
        is1 = 1;
	    tfl = 1;
	    tlab = 'torque pu and power factor';
	    ilab = 'p,q and i pu';
    else
        [zr,zi,xss,xrs,rres,xres,is1,ir1]=zdc(rs,xs,Xm,xr1,xr2,rr1,rr2,V,sfl,isat);
        tfl = ir1*ir1*rres/sfl;
        is1 = abs(nll+1/(zr+i*zi));
        tlab = 'torque/torque full load and power factor';
        ilab = 'p and q pu, and i/i full load';
    end
    nplt = 0;
case 12
    if sfl ==0
        is1 = 1;
	    tfl = 1;
	    tlab = 'torque pu and power factor';
	    ilab = 'p,q and i pu';
    else
        [zr,zi,xss,xrs,rres,xres,is1,ir1]=zdc(rs,xs,Xm,xr1,xr2,rr1,rr2,V,sfl,isat);
        is1 = abs(nll+1/(zr+i*zi));
        tfl = ir1*ir1*rres/sfl;
        tlab = 'torque/torque full load and power factor';
        ilab = 'p and q pu, and i/i full load';
    end
end

if ~nplt
	figure
	[AX,H1,H2]=plotyy(s,[t/tfl;pfact],s,[p;q;is/is1]);hold
	xlabel('speed pu');
	set(get(AX(1),'Ylabel'),'String',tlab)
    set(get(AX(1),'Ylabel'),'String',tlab)
	set(AX(1),'YLim',[0 ceil(max(t/tfl))])
    set(AX(2),'YLim',[0 ceil(max(is/is1))])
	title('induction motor steady state speed charateristics');
	legend(AX(1),{'torque' 'power factor'},2);legend(AX(2),{'power' 'reactive power' 'current'},1)
end