function [a,b,c,d] = stack(varargin)
%forms a single sparse state space with the original inputs and outputs
%syntax: [a,b,c,d] = stack(s1,s2,s3,....sn)

vn = length(varargin);
a=sparse([]);b=sparse([]);c=sparse([]);d=sparse([]);ns=0;no=0;ni=0;
for k = 1:vn
   n_ss = find(cellfun('isclass',varargin{k},'stsp')==0);
   nss = length(varargin{k});
   if ~isempty(n_ss) 
      error(['the ' int2str(k) ' input contains non_stsp objects at indexes at' int2str(n_ss)])
   else
      s = varargin{k};
      if nss==1
         sv = get(s);
         nsn = ns+sv.NumStates;
         non = no+sv.NumOutputs;
         nin = ni+sv.NumInputs;
         a(ns+1:nsn,ns+1:ns) = sparse(sv.a);
         b(ns+1:nsn,ni+1:nin)=sparse(sv.b);
         c(no+1,non,ns+1:nsn)=sparse(sv.c);
         d(no+1:non,ni+1:nin)=sparse(sv.d);
         ns = nsn; no = non;ni = nin;
      else   
         for kk = 1:nss
            sv = get(s{kk});
            nsn = ns+sv.NumStates;
            non = no+sv.NumOutputs;
            nin = ni+sv.NumInputs;
            a(ns+1:nsn,ns+1:nsn) = sparse(sv.a);
            b(ns+1:nsn,ni+1:nin)=sparse(sv.b);
            c(no+1:non,ns+1:nsn)=sparse(sv.c);
            d(no+1:non,ni+1:nin)=sparse(sv.d);
            ns = nsn; no = non;ni = nin;
         end
      end
   end
end