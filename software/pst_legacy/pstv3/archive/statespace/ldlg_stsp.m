function sll = ldlg_stsp(K,Td,Tn)
% sll = K(1+sTn)/1+sTd)
%syntax s = ldlg_stsp(K,Td,Tn)
% forms a state space object for K(1+sTn)/(1+sTd)
% if K, Td and Tn are vectors of the same length
% the output is a stacked state space object

% (c) copyright Cherry Tree Scientific Software 1997-1999
% All rights reserved

Td_idx = find(Td~=0);
noTd_idx = find(Td==0);
if length(K)~=length(Td)||length(K)~=length(Tn)
   error('the lengths of K,Td and Tc must be equal')
else
   ns = length(Td_idx);n_io = length(Td);
   if ns~=0;
      a = diag(-1./Td(Td_idx));
      b = zeros(ns,n_io);
      b(:,Td_idx) = diag((ones(ns,1)-Tn(Td_idx)./Td(Td_idx))./Td(Td_idx));
      c = zeros(n_io,ns);
      c(Td_idx,:) =diag(K(Td_idx)); 
      d = zeros(n_io);
      d(Td_idx,Td_idx) = diag(K(Td_idx).*Tn(Td_idx)./Td(Td_idx));
      d(noTd_idx,noTd_idx) =diag( K(noTd_idx));
      sll = stsp(a,b,c,d);
   else
      sll = stsp([],[],[],diag(K));
   end
end
