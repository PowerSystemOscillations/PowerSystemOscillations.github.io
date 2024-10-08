function [zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,v,s,isat)
% syntax: [zr,zi,xss,xrs,is1,ir1]=zdc(rs,xs,Xm,xr,rr,v,s,isat)
% Purpose: Calculates the impedances and currents for a single cage 
% rotor at a particular slip and terminal voltage
% Leakage inductance saturation is taken into account
% Inputs
% rs	-	stator leakage resistance pu
% xs	-	stator leakage reactance
% Xm	-	magnetizing reactance pu	
% xr	-	rotor leakage reactance pu
% rr	-	rotor resistance pu
% v		-  	voltage pu
% s		-	fractional slip
% isat	-	leakage inductance satuation current pu
% Outputs	
% zr	-	real motor impedance
% zi	-	imaginary rotor impedance
% xss	-	saturated value of xs
% xrs	- 	saturated value of xr
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
    xss = xs;
    xrs = xr;
	is1 = v / sqrt(zr ^ 2 + zi ^ 2);
	ir1 = 0;
	return
end
err1 = 1;err2 = 1;
xs1 = xs;xr1=xr;
nc = 0;
while ((err1>5e-5)|(err2>5e-5))&nc<50
    nc = nc+1;
	zr = rr/s+i*xr1;zm = i*Xm;
    zs = rs+i*xs1;
    z = zs+zr*zm/(zr+zm);
    is = v/z;
    ir = is*zm/(zr+zm);
	is1 = abs(is);
	ir1 = abs(ir);
	xr11 = xr * (1 + dessat(ir1,isat))/2;
	xs11 = xs * (1 + dessat(is1,isat))/2;
	err1 = abs((xr11 - xr1) / xr1);
	err2 = abs((xs11 - xs1) / xs1);
	xr1 = xr11;
	xs1 = xs11;
end
if nc==50
	uiwait(msgbox('saturation reactance calculation not converged','zdc error','modal'))
	eflag = 1;
end
xrs = xr1;xss=xs1;
zr = real(z);zi=imag(z);