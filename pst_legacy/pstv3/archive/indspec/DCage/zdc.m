function [zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdc(rs,xs,Xm,xr1,xr2,rr1,rr2,v,s,isat);
% syntax: [zr,zi,xss,xrs,rre,xre,is1,ir1]=zdc(rs,xs,Xm,xr1,xr2,rr1,rr2,v,s,isat)
% Purpose: Calculates the impedances and currents for a single cage 
% rotor equivalent to a double cage rotor at a particular slip and 
% terminal voltage
% Leakage inductance saturation is taken into account
% Inputs
% rs	-	stator leakage resistance pu
% xs	-	stator leakage reactance
% Xm	-	magnetizing reactance pu	
% xr1	-	first cage leakage reactance pu
% xr2	-	second cage leakage reactance pu
% rr1	-	first cage rotor resistance pu
% rr2	-	second cage rotor resistance pu
% v		-  	voltage pu
% s		-	fractional slip
% isat	-	leakage inductance satuation current pu
% Outputs	
% zr	-	real motor impedance
% zi	-	imaginary rotor impedance
% xss	-	saturated value of xs
% xrs	- 	saturated value of xr1
% rre	-	equivalent resistance of double cage
% xre	-	equivalent reactance of double cage
% is1	-	stator current magnitude
% ir1	-	rotor current magnitude
% eflag - 	1 if process not converged


% December 6, 2002
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2002 - All Rights Reserved

eflag = 0;
if s == 0
    % zero rotor current
	zr = rs;
	zi = Xm + xs;
	is1 = v / sqrt(zr ^ 2 + zi ^ 2);
	ir1 = 0;
	rre = rr1*rr2/(rr1+rr2);
	xre = xr1+(rre.*rre)./(rr2.*rr2).*xr2;
    xss = xs;
    xrs = xr1;
	return
end
err1 = 1;err2 = 1;
[rre,xre] = dbcage(rr1,xr1,rr2,xr2,s);
xs1 = xs;
xss = xs;xrs=xr1;
nc = 0;
while ((err1>5e-5)|(err2>5e-5))&nc<50
    nc = nc+1;
	zr = rre/s+i*xre;zm = i*Xm;
    zs = rs+i*xs1;
    z = zs+zr*zm/(zr+zm);
    is = v/z;vr = is*zr*zm/(zr+zm);
    ir = vr/zr;
	is1 = abs(is);
	ir1 = abs(ir);
	xr11 = xrs * (1 + dessat(ir1,isat))/2;
	xs11 = xss * (1 + dessat(is1,isat))/2;
	err1 = abs((xr11 - xr1) / xr1);
	err2 = abs((xs11 - xs1) / xs1);
	xr1 = xr11;
	xs1 = xs11;
	[rre,xre] = dbcage(rr1,xr1,rr2,xr2,s);
end
if nc==50
	uiwait(msgbox('saturation reactance calculation not converged','zdc error','modal'))
	eflag = 1;
end
zr = rre/s+i*xre;zm = i*Xm;
zs = rs+i*xs1;
z = zs+zr*zm/(zr+zm);
xrs = xr1;xss=xs1;
zr = real(z);zi=imag(z);