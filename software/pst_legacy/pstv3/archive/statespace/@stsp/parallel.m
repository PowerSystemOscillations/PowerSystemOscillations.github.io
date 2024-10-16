function st = parallel(varargin)
%parallels state space objects and creates a new state space object
%syntax st = parallel(s1,s2,s3,......sn)
%inputs state space objects with the same number of ouputs and inputs
%output a new state space object representing the parallel combination
%inputs are paralleled
%outputs are summed

% (c) copyright Cherry Tree Scientific Software 1997-1999
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
   eo = find(no(1)==no);
   ei = find(ni(1)==ni);
   if length(eo)~=length(no)
      error('all state space objects must have the same number of outputs')
   elseif length(ei)~=length(ni)
      error('all state space objects must have the same number of inputs')
   end
   nst=1;ns=0;ni=ni(1);no=no(1);
   if notsp
       d = zeros(no,ni);b = zeros(ns,ni);c=zeros(no,ns);a=zeros(ns,ns);
   else
       d=sparse(no,ni);a = sparse(ns,ns); b=sparse(ns,ni); c=sparse(no,ns);
   end
   for k = 1:nss
       if notsp
            if varargin{k}.NumStates~=0
                ns=ns + varargin{k}.NumStates;
                a(nst:ns,nst:ns)=full(varargin{k}.a);
                b(nst:ns,1:ni)=full(varargin{k}.b);
                c(1:no,nst:ns)=full(varargin{k}.c);
            end
            d = d+full(varargin{k}.d);
            nst = nst+varargin{k}.NumStates;
        else
            if varargin{k}.NumStates~=0
                ns=ns + varargin{k}.NumStates;
                a(nst:ns,nst:ns)=sparse(varargin{k}.a);
                b(nst:ns,1:ni)=sparse(varargin{k}.b);
                c(1:no,nst:ns)=sparse(varargin{k}.c);
            end
            d = d+sparse(varargin{k}.d);
            nst = nst+varargin{k}.NumStates;
        end
   end   
   st=stsp(a,b,c,d);
end
