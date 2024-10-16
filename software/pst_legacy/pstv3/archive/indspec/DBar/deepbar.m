function [r,x]=deepbar(rro,B,s)
% gives the equivalent rotor leakage reactance and resistance as a funtion of slip
% B is the deep bar factor
% s is the slip
% rro is the value of rotor resistance at s = 0;
% r is the effective rotor resistance
% x is the effective rotor reactance

% December 6, 2002
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2002 - All Rights Reserved

b = sqrt(abs(s)).*B;
r0 = rro/2;
r = rro;
x = (rro.*B.*B)/6;
nzsi = find(s~=0);
if ~isempty(nzsi)
	a = (1+i)*b(nzsi);
	z = r0(nzsi).*a.*(exp(a)+1)./(exp(a)-1);
	r(nzsi) = real(z);x(nzsi)=imag(z)./s(nzsi);
end