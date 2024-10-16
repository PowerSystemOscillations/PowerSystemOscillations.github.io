function sw=wo_stsp(T);
% sw = sT/(1+sT)
%syntax: s = wo_stsp(T)
%forms a washout state space object  sT/(1+sT)
% if T is a vector forms a stacked state space object
% if there are no input arguments, input passes trough unalterd s =
% stsp([],[],[],1)

% (c) copyright Cherry Tree Scientific Software 1997-1999
% All rights reserved

if nargin==0;
   sw = stsp([],[],[],1);
   uiwait(msgbox('with no arguments wo_stsp creates s = stsp([],[],[],1)','stsp warning', 'modal'));
   return
end
Tnz = T~=0;
T_idx = find(Tnz);
nt = length(T);ns = length(T_idx);
b=zeros(ns,nt);
c = zeros(nt,ns); d = eye(nt);
if ~isempty(T_idx)
   a = diag(-1./T(T_idx));b(:,T_idx)=diag(1./T(T_idx));
   c(T_idx,:)=-eye(ns);
else
   a = [];b=[];c=[];
end
sw = stsp(a,b,c,d);
