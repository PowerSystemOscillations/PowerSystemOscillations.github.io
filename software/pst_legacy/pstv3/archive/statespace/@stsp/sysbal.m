% function [sbal,sig] = sysbal(s,tol)
%
%   Finds a truncated balanced realization of the
%   stsp object s. Eigenvalues of s must have negative
%   real parts. The result is truncated to retain all Hankel-
%   singular values greater than to. If tol is omitted
%   then it is set to max(sig(1)*1.0e-12,1.0e-16).
%


function [sbal,sig] = sysbal(s,tol)
   if nargin == 0
     disp(['usage: [sbal,sig] = sysbal(s,tol)']);
     return
   end %if nargin<1

   A=s.a;B=s.b;C=s.c;D=s.d;
   [n,m]=size(B); [p,n]=size(C);
   [T,A]=schur(A);
   B = T'*B;
   C = C*T;
 % check that A is stable.
   if any(real(eig(A))>=0),
     disp('s must be stable')
     return
    end

 % find observability Gramian, S'*S (S upper triangular)
   S = sjh6(A,C);
 % find controllability Gramian R*R' (R upper triangular)
   perm = n:-1:1;
   R = sjh6(A(perm,perm)',B(perm,:)');
   R = R(perm,perm)';
 % calculate the Hankel-singular values
   [U,T,V] = svd(S*R);
   sig = diag(T);
 % balancing coordinates
   T = U'*S;
   B = T*B; A = T*A;
   T = R*V;
   C = C*T; A = A*T;
    % calculate the truncated dimension nn
   if nargin<2 tol=max([sig(1)*1.0E-12,1.0E-16]);end;
   nn = n;
   for i=n:-1:1, if sig(i)<=tol nn=i-1; end; end;
   if nn==0, sbal=stsp([],[],[],D);
   else
       sig = sig(1:nn);
       % diagonal scaling  by sig(i)^(-0.5)
       irtsig = sig.^(-0.5);
       onn=1:nn;
       A(onn,onn)=A(onn,onn).*(irtsig*irtsig');
       B(onn,:)=(irtsig*ones(1,m)).*B(onn,:);
       C(:,onn)=C(:,onn).*(ones(p,1)*irtsig');
       sbal=stsp(A(onn,onn),B(onn,:),C(:,onn),D);
   end


%
%
