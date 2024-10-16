function [zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,v,s,isat)
% syntax: [zr,zi,xss,xrs,rre,xre,is1,ir1]=zdb(rs,xs,Xm,xr,rr,dbf,v,s,isat)
% Purpose: Calculates the impedances and currents for a deep bar 
% rotor equivalent to a deep bar rotor at a particular slip and 
% terminal voltage
% Leakage inductance saturation is taken into account
% Inputs
%	rs		stator resistance pu
%	xs		stator leakage reactance pu
%	Xm		magnetizing reactance pu
%	xr		rotor leakage reactance pu
%   rr		rotor resisance at zero slip
%	dbf		deep bar factor
%	v		terminal voltage pu
%	s		fractional slip
%	isat	leakage inductance saturation current pu
% Outputs
%	zr		real stator impedance
%	zi		imaginary stator impedance
%  	xss		saturated value of stator leakage reactance
%	xrs		saturated value of rotor leakage reactance
%	rre		effective resistance of deep bar
%	xre		effective reactance of deep bar
%	eflag	if efag = 1, solution not converged

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
	rre = rr;
	xre = (rr.*dbf.*dbf)/6;
	return
end
err1 = 1;err2 = 1;
[rre,xre] = deepbar(rr,dbf,s);
xrs=xr;xss = xs;nc = 0;
while ((err1>5e-5)||(err2>5e-5))&&nc<50
    nc=nc+1;
	zr = rre/s+i*(xre+xrs);zm = i*Xm;
    zs = rs+i*xss;
    z = zs+zr*zm/(zr+zm);
    is = v/z;
    ir = is*zm/(zr+zm);
	is1 = abs(is);
	ir1 = abs(ir);
	xrs1 = 0.5*xr * (1 + dessat(ir1,isat));
	xss1 = 0.5*xs * (1 + dessat(is1,isat));
	err1 = abs((xrs1 - xrs) / xrs);
	err2 = abs((xss1 - xss) / xss);
	xrs = xrs1;
	xss = xss1;
end
if nc==50
	uiwait(msgbox('saturation reactance calculation not converged','zdb error','modal'))
	eflag = 1;
end
zr = real(z);zi=imag(z);