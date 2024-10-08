function [l,u,v,p,sm] = eig(s,tol)
% overrides the normal eigenvalue function for state space objects
% if s.a is sparse converts to full
if ~isa(s,'stsp')
   error(' s must be a state space object')
else
   if nargin==1;tol = 1e6;end
   [U,T]=schur(full(s.a));
   [u,l,sc]=condeig(T);
   [l, l_idx] = sort(diag(l));
   u = u(:,l_idx);sc = sc(l_idx);
   %Scale complex eigenvectors so that the maximum magnitude is 1+i*0
   for k = 1:s.NumStates
      if imag(l(k))~=0
         [maxu, mu_idx] = max(abs(u(:,k)));
         u(:,k)=u(:,k)/u(mu_idx,k);
      end
   end
   % check for nearly equal eigenvectors
   eu_idx = find(sc>tol);
   neu=0;ld=l;
   if ~isempty(eu_idx)
       neu = length(eu_idx);
       if neu>=2
           ld = diag(l);
           disp('some eigenvectors are equal')
           disp('output will be in Jordan Cannonical Form')
           disp(['number of equal eigenvectors = ' int2str(neu)])
           if neu==2
               u(:,eu_idx(2))=pinv(T-l(eu_idx(1))*eye(s.NumStates))*u(:,eu_idx(1));
               ld(eu_idx(1),eu_idx(2))=1;
           else
               % multiple equal eigenvectors
               kk = 1;
               while kk<neu
                   nek_idx = find(real(l-l(eu_idx(kk))*ones(s.NumStates,1))<1e-6...
                       &imag(l-l(eu_idx(kk))*ones(s.NumStates,1))<1e-6);
                   if ~isempty(nek_idx)
                       pik = pinv(s.a-l(eu_idx(kk))*eye(s.NumStates));
                       nek = length(nek_idx);
                       for nk = 1:nek-1
                           u(:,eu_idx(kk)+nk)=pik*u(:,eu_idx(kk)+nk-1);
                           ld(eu_idx(kk)+nk,eu_idx(kk)+nk-1)=1;
                       end
                   end
                   kk = kk+nek;
               end
           end
       end
   end
   l=ld;
   u=U*u;
   v = inv(u);
   %index = find(abs(l)<1e-6);
   l(abs(l)<1e-6)=0;
   lr=real(l);li=imag(l);index=find(abs(lr)<1e-6);lr(index)=0;l(index)=lr(index)+i*li(index);
   p = u.*v.';
   if neu<=1;a = diag(l);else a = l;end
   b = v*s.b;
   c = s.c*u;
   d = s.d;
   sm = stsp(a,b,c,d);
end