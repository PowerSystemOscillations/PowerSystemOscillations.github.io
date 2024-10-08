% function [sst,sun] = sdecomp(s,bord,fl)
%
%   Decomposes a system into the sum of two systems,
%      SYS = MADD(SYSST,SYSUN).
%      SST has the real parts of all its poles < BORD
%      SUN has the real parts of all its poles >= BORD
%      BORD has default value 0.
%
%    The D matrix for SYSUN is zero unless FL = 'd' when
%    that for SYSST is zero.
%



function [sst,sun] = sdecomp(s,bord,fl)
  if nargin < 1
    disp('usage: [sst,sun] = sdecomp(s,bord,fl)')
    return
  end

if nargin==1, bord=0;fl='s'; end
if nargin==2, fl='s';end

a=s.a;b=s.b;c=s.c;d=s.d;n=s.NumStates;p=s.NumInputs;m=s.NumOutputs;
[u,a]=schur(a);
[u,a,k]=orsf(u,a,'s',bord);

if isempty(k), sst=stsp; sun=s; end
if ~isempty(k) & k==n 
	sst=s;
	sun=stsp;
end
kp=k+1;
if k<n & k>0,
  x=axxbc(a(1:k,1:k),-a(kp:n,kp:n),-a(1:k,kp:n));
  ah=a(1:k,1:k);
  bh=[eye(k),-x]*u'*b;
  ch=c*u(:,1:k);
  if fl=='s', dh=d; du=zeros(p,m);
     else, du=d; dh=zeros(p,m); end
  sst=stsp(ah,bh,ch,dh);
  au=a(kp:n,kp:n);
  bu=u(:,kp:n)'*b;
  cu=c*u*[x;eye(n-k)];
  sun=stsp(au,bu,cu,du);
 end 
