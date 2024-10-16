function [t,p,q,pfact,is,s,tfl,isfl]=scimtspeed(V,rs,xs,Xm,rr,xr,nll,isat,sfl,nplt)
% calculates induction motor steady state torque speed characteristics as a function of slip
% Inputs
% V 	-	motor voltage magnitude in PU on motor base
% rs 	-	stator resistance in PU on motor base
% xs 	-	stator leakage reactance in PU on motor base
% rr 	-	rotor resistance in PU on motor base
% xr 	-	rotor leakage reactance in PU on motor base
% nll   -   no load loss
% isat 	-	the current at which leakage inductance saturation starts
% sfl	-	full load slip 
% if nplt==1, there is no plot
% Note: 	if sfl not supplied or zero plots give unnormalized torque and current
% Outputs
% t		-	vector of torques pu
% p		-	vector of active powers pu
% q		-	vector of reactive powers pu
% pfact -   vector of power factors
% is	-	vector of stator current pu
% s		-	vector of motor speed pu
% tfl   -   full load torque if full load slip specified, otherwise unity
% is1   =   full load current if full load slip specified, otherwise unity

% December 6, 2002
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2002 - All Rights Reserved

for ns = 1001:-1:2
    s(ns) = 0.001*(ns-1);
    [zr,zi,xss,xrs,is1,ir1]=zsc(rs,xs,Xm,xr,rr,V,s(ns),isat);
    t(ns) = ir1*ir1*rr/s(ns);
    is(ns) = V*(nll+1/(zr+i*zi));
    p(ns) = V*real(is(ns));q(ns) = -V*imag(is(ns));  
    pfact(ns) = p(ns)/abs(p(ns)+i*q(ns));
end

s=1-s;
is = abs(is);
tlab = 'torque/torque full load and power factor';
ilab = 'p and q pu and i/i full load';
switch nargin
case 8
	is1 = 1;
	tfl = 1;
    pffl = 1;
	tlab = 'torque pu and power factor';
	ilab = 'p,q, and i pu';
    nplt = 0;
case 9
    if sfl ==0
        is1 = 1;
	    tfl = 1;
        pffl = 1;
	    tlab = 'torque pu and power factor';
	    ilab = 'p,q, and i pu';
    else
        [zr,zi,xss,xrs,is1,ir1]=zsc(rs,xs,Xm,xr,rr,V,sfl,isat);
        is1 = nll+1/(zr+i*zi);
        tfl = ir1*ir1*rr/sfl;
        pffl = cos(angle(is1));
        is1 = abs(is1);
    end
    nplt=0;
case 10
    if sfl ==0
        isfl = 1;
	    tfl = 1;
        pffl = 1;
	    tlab = 'torque pu and power factor';
	    ilab = 'p,q, and i pu';
    else
        [zr,zi,xss,xrs,is1,ir1]=zsc(rs,xs,Xm,xr,rr,V,sfl,isat);
        is1 = nll+1/(zr+i*zi);
        tfl = ir1*ir1*rr/sfl;
        pffl = cos(angle(is1));
        isfl = abs(is1);
    end
end
[zr,zi,xss,xrs,is1,ir1]=zsc(rs,xs,Xm,xr,rr,V,sfl,isat);
tfl = ir1*ir1*rr/sfl;
is1 = nll+1/(zr+i*zi);
pffl = cos(angle(is1));
isfl = abs(is1);
if ~nplt
    figure
	[AX,H1,H2]=plotyy(s,[t/tfl; pfact],s,[p;q;is/isfl]);hold
	xlabel('speed pu');
	set(get(AX(1),'Ylabel'),'String',tlab)
	set(get(AX(2),'Ylabel'),'String',ilab)
    set(AX(1),'YLim',[0 ceil(max(t/tfl))])
    set(AX(2),'YLim',[0 ceil(max(is/is1))])
	title('single cage induction motor steady state speed charateristics');
	legend(AX(1),{'torque' 'power factor'},2);legend(AX(2),{'power' 'reactive power' 'current'},1)
end