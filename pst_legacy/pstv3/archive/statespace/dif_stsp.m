function d=dif_stsp(T);
% s/(1+sT)
% syntax s=dif_stsp(T)
% forms an imperfect differentiator state space object
% if T is zero gain is set to zero

% (c) copyright Cherry Tree Scientific Software 1997-2005
% All rights reserved

if nargin==0
    T=0.01;
end
nzt = find(T~=0);zt=find(T==0);
d=zeros(length(T));
a=diag(T);b=a;c=a;d=a;
if~isempty(nzt)
    a(nzt,nzt)=diag(-1./T(nzt));
    b(nzt,nzt)=a(nzt,nzt);
    c(nzt,nzt)=-a(nzt,nzt);
    d(nzt,nzt)=-a(nzt,nzt);
end
d = stsp(a,b,c,d);