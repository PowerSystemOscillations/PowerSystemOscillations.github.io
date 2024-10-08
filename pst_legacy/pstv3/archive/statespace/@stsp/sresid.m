% function sres = sresid(s,ord)
%
%   Reduces the stsp (s) object of order n to a reduced order stsp object
%   sres of order ord
%   Eliminates the last n-ord states by assuming that the rate of change of
%   these states are zero.
%


function sres = sresid(s,ord)
if nargin ~= 2
    disp('usage: sres = sresid(s,ord)')
    return
end
if isempty(ord)
    return
end
if ord < 0 | (floor(ord) ~= ceil(ord))
    error(['ord should be a nonnegative integer'])
    return
end
NumStates=s.NumStates;
nrs = NumStates-ord;
ar = s.a(1:ord,1:ord);
br = s.b(1:ord,:);
cr = s.c(:,1:ord);
dr = s.d;
adr = s.a(ord+1:NumStates,1:ord);
cd = s.c(:,1:ord);
ard = s.a(1:ord,ord+1:NumStates);
crd = s.c(:,ord+1:NumStates);
bdr = s.b(ord+1:NumStates,:);
add = s.a(ord+1:NumStates,ord+1:NumStates);
xd = -add\[adr bdr];
a = ar + ard*xd(:,1:ord);
b = br + ard*xd(:,ord+(1:s.NumInputs));
c = cr+ crd*xd(:,1:ord);
sres = stsp(a,b,c,dr);
%
%
