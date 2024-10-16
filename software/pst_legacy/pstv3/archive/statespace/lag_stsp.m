function sl = lag_stsp(K,Tc)
% sl = K/(1+sT)
%syntax sl = lag_stsp(K,Tc)
% forms state space object for K/(1 +sTc)
% if Kc and Tc are vectors of equal length forms a stacked state matrix
% (c) copyright Cherry Tree Scientific Software 1997-1999
% All rights reserved

Tc_idx = find(Tc~=0);
noTc_idx = find(Tc==0);
n_state = length(Tc_idx);n_io = length(Tc);
if length(K)~=length(Tc)
   error('the length of K and Tc must be the same')
elseif n_state~=0
   a = diag(-1./Tc(Tc_idx));
   b = zeros(n_state,n_io);
   b(:,Tc_idx) = diag(1./Tc(Tc_idx));
   c = zeros(n_io,n_state);
   c(Tc_idx,:)=diag(K(Tc_idx));
   d = zeros(n_io);
   d(noTc_idx,noTc_idx)=diag(K(noTc_idx));
   sl = stsp(a,b,c,d);
else
   a = [];
   b = [];
   c = [];
   d = diag(K);
   sl = stsp(a,b,c,d);
end  