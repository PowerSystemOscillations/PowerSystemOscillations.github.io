function ss = vertcat(varargin)
%combines state space objects into a single stacked state space object
%syntax ss = vertcat(s1,s2,s3,s4,.....sn) or ss = [s1;s2;s3;s4;s5;.....sn]
%inputs must all be state space objects
% 
% output a single state space object with 
%                   output equal to output of each of the state space objects
%                   input equal to the input of each of the state space objects
%                   ss.a = diag(s1.a;s2.a;s3.a;s4.a .....) etc.
% overloads MATLAB vertcat for state space objects
% (c) copyright Cherry Tree Scientific Software 1997-1999
% All rights reserved

vstsp = cellfun('isclass',varargin,'stsp');
not_ss = find(vstsp==0);
if ~isempty(not_ss)
   error('all inputs must be state space objects')
else
   nss = length(varargin);
   spf = 0;
   for k = 1:nss
      s = varargin{k};
      if ~spf;spf = issparse(s.a);end
      ns(k) =s.NumStates ;
      no(k)	= s.NumOutputs ;
      ni(k) = s.NumInputs;
   end
   nst = sum(ns);nit = sum(ni);not = sum(no);
   a=sparse(zeros(nst));b=sparse(zeros(nst,nit));
   c = sparse(zeros(not,nst));d = sparse(zeros(not,nit));
   ns1=0;ni1=0;no1=0;
   for k = 1:nss
      s = sparse(varargin{k});
      if ~isempty(s.a);
      	a(ns1+1:ns1+ns(k),ns1+1:ns1+ns(k))=s.a;
      	b(ns1+1:ns1+ns(k),ni1+1:ni1+ni(k))=s.b;
         c(no1+1:no1+no(k),ns1+1:ns1+ns(k))=s.c;
      end
      d(no1+1:no1+no(k),ni1+1:ni1+ni(k))=s.d;
      ns1 = ns1+ns(k);ni1 = ni1+ni(k);no1=no1+no(k);
   end
   if spf
      ss = stsp(a,b,c,d);
   else
      ss = stsp(full(a),full(b),full(c),full(d));
   end
 end