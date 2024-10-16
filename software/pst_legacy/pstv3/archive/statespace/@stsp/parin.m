function st = parin(varargin)
%parallels inputs state space objects and creates a new state space object
%syntax st = parin(s1,s2,s3,......sn)
%inputs state space objects each with the same number of inputs
%output a new state space object with the inputs are paralleled
%outputs are unchanged

% (c) copyright Cherry Tree Scientific Software 1997-2004
% All rights reserved

vstsp = cellfun('isclass',varargin,'stsp');
not_ss = find(vstsp==0);
if ~isempty(not_ss)
   error('all inputs must be state space objects')
else
   nss=length(varargin);
   % check statistics
   for k = 1:nss
      no(k) =varargin{k}.NumOutputs;
      ni(k) =varargin{k}.NumInputs;
      ns(k) = varargin{k}.NumStates;
      isp(k) = issparse(varargin{k}.a)|(isempty(varargin{k}.a)&issparse(varargin{k}.d));
   end
   notsp = sum(isp)~=nss;
   ei = find(ni(1)==ni);
   if length(ei)~=length(ni)
      uiwait(msgbox('all state space objects must have the same number of inputs','parin error','modal'))
      st=stsp;
      return
   end
   nst=1;nstot=sum(ns);ni=ni(1);no=no(1);notot = sum(no);
   if notsp
       d = zeros(notot,ni);b = zeros(nstot,ni);c=zeros(notot,nstot);a=zeros(nstot,nstot);
   else
       d=sparse(notot,ni);a = sparse(nstot,nstot); b=sparse(nstot,ni); c=sparse(notot,nstot);
   end
   ns=0;nout = 0;nos=1;
   for k = 1:nss
       nout = nout+varargin{k}.NumOutputs;
       if notsp
            if varargin{k}.NumStates~=0
                ns=ns + varargin{k}.NumStates;
                a(nst:ns,nst:ns)=full(varargin{k}.a);
                b(nst:ns,:)=full(varargin{k}.b);
                c(nos:nout,nst:ns)=full(varargin{k}.c);
            end
            d(nos:nout,:) = full(varargin{k}.d);
            nst = ns+1;
            nos = nout+1;
        else
            if varargin{k}.NumStates~=0
                ns=ns + varargin{k}.NumStates;
                a(nst:ns,nst:ns)=sparse(varargin{k}.a);
                b(nst:ns,:)=sparse(varargin{k}.b);
                c(nos:nout,nst:ns)=sparse(varargin{k}.c);
            end
            d(nos:nout,:) = full(varargin{k}.d);
            nst = ns+1;
            nos = nos+nout;
        end
   end   
   st=stsp(a,b,c,d);
end
