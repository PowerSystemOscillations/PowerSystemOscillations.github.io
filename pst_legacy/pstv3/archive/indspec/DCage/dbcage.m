function [r,x]=dbcage(r1,x1,r2,x2,s);
% calculates the equivalent rotor resistance and reactance of a double cage rotor
% with slip (s)
% called by mac_ind
s=abs(s);
r = r1.*r2./(r1+r2);
x = x1+(r.*r)./(r2.*r2).*x2;
nzsi = find(s~=0);
if ~isempty(nzsi)
	z = i*s(nzsi).*x1(nzsi) + r1(nzsi).*(r2(nzsi) + i*s.*x2(nzsi))./((r1(nzsi)+r2(nzsi)) + i*s.*x2(nzsi));
	r(nzsi) = real(z);
	x(nzsi) = imag(z)./s;
end
