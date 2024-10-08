function [sfba,in1,in2,out1,out2] = fb_aug(s1,s2,fb1,fb2)
%connects  s2 in positive feedback around s1
%syntax [sfba,in1,in2,out1,out2] = fb(s1,s2,fb1,fb2)
%Inputs:
% s1 - forward loop state space object
% s2 - feedback loop state space object
% fb1 -  structure defining input and output indexes which define the feedback for s1
% fb2 -  structure defining input and output indexes which define the feedback for s2
%        each fb has the form
%        fb.NumInputs
%        fb.NumOutputs
%        fb.i_idx
%        fb.o_idx
%        fb.ri_idx
%        fb.ro_idx
%        the number of outputs defined in fb1 must be the same as the number of inputs defined in fb2
%        the number of inputs defined in fb1 must be the same as the number of outputs defined in fb2
%        the feedback inputs and outputs are defined by the i_idx and o_idx indexes
%        the inputs of sfba are the inputs of s1 defined by fb1.ri_idx 
%        together with the inputs of s2 defined by fb2.ri_idx
%        the outputs of sfba are the outputs of s1 defined by fb1.ro_idx 
%        and the outputs of s2 defined by fb2.ro_idx
%
% if fb1 and fb2 are not supplied:
%                    the inputs and outputs of s1 are retained
%                    the input to s2 is the output of s1
%                    the output of s2 plus the original inputs of s1 are the inputs to s1
%OutPuts:
% sfba - closed loop state space object
% in1 - correspondence between inputs to sfba and inputs to s1
% in2 - correspondence between inputs to sfba and inputs to s2
% out1 - correspondence between outputs of sfba and outputs of s1
% out2 - correspondence between outputs of sfba and outputs of s2


% date March 7 1998
%author Graham Rogers
%copyright Cherry Tree Scientific Software 1998-2002 all rights reserved

%date April 11 2002
%modified simple use sfba = fb_aug(s1,s2) to correct errors and to detect
%singular case



if ~isa(s1,'stsp')
   %must be a scalar gain vector
   %if -isa(s2,'stsp')
   %   error('s2 must be a state space object if s1 is a scalar')
   %elseif isempty(s2.a)
   %   error('either s1 or s2 must be dynamic')
   %end
   if issparse(s2.a)
      s1 = sparse(stsp([],[],[],s1));
   else
      s1 = stsp([],[],[],s1);
   end
end
if ~isa(s2,'stsp')
   %must be a scalar feedback vector
   %if nots1==1
   %   error('s1 must be a state space object if s2 is a scalar')
   %elseif isempty(s1.a)
   %   error('either s1 or s2 must be dynamic')
   %end
   if issparse(s1.a)
      s2 = sparse(stsp([],[],[],s2));
   else
      s2 = stsp([],[],[],s2);
   end
end
%check consistency
if nargin==2
   if s1.NumOutputs~=s2.NumInputs
      error('the number of outputs of s1 must equal the number of inputs of s2')
   end
   if s1.NumInputs~=s2.NumOutputs
      error('the number of inputs of s1 must equal the number of outputs of s2')
   end
   if issparse(s1.a)&&~issparse(s2.a);s2 = sparse(s2);end
   if issparse(s2.a)&&~issparse(s1.a);s1 = sparse(s1);end
   
   ns1 = s1.NumStates;
   ns2 = s2.NumStates;
   ns = ns1 + ns2;
   no1=s1.NumOutputs;
   ni1 = s1.NumInputs;
   no = no1;
   ni = ni1;
   a = sparse([]);b=sparse([]);c=sparse([]);
   if s1.d*s2.d==eye(no1)
       uiwait(msgbox('feed back connection gives unrealizable system','fb_aug error','modal'))
       error('unrealizable feedback system')
   end
   di = inv(sparse(eye(no1))-s1.d*s2.d);
   if ns~=0;
      a =sparse(zeros(ns));
      b = sparse(zeros(ns,ni));
      c = sparse(zeros(no,ns));  
      if ns1~=0
         a(1:ns1,1:ns1) = s1.a + s1.b*s2.d*di*s1.c;
         c(:,1:ns1)=di*s1.c;
         b(1:ns1,:)= s1.b+s1.b*s2.d*di*s1.d;
         if ns2~=0
            a(1:ns1,1+ns1:ns) = s1.b*(s2.c+s2.d*di*s1.d*s2.c);
            b(1+ns1:ns,:) = s2.b*di*s1.d;
            c(:,1:ns1)=c(:,1:ns1)+s1.d*s2.d*di*s1.c;
         end
      end
      if ns2~=0
         a(ns1+1:ns,ns1+1:ns)=s2.a + s2.b*di*s1.d*s2.c;
         b(ns1+1:ns,:)=s2.b*di*s1.d;
         c(:,1+ns1:ns) =s1.d*(s2.c + di*s1.d*s2.c);
         if ns1~=0
            a(1+ns1:ns,1:ns1)= s2.b*di*s1.c;
         end
      end
   end
   d = s1.d+s1.d*s2.d*di*s1.d;
   if ~issparse(s1.a)&&~issparse(s2.a)
      sfba = stsp(full(a),full(b),full(c),full(d));
   else
      sfba = stsp(a,b,c,d);
   end
else
   % feedback inputs and outputs specified in fb1 and fb2
   if fb1.NumOutputs ~= fb2.NumInputs
      error('the number of feedback outputs of s1 must equal the number of feedback inputs of s2')
   end
   if fb1.NumInputs ~= fb2.NumOutputs
      error('the number of feedback inputs of s1 must equal the number of feedback outputs of s2')
   end
   if isempty(fb1.i_idx);error('s1 must have feedback inputs defined');end
   if isempty(fb1.o_idx);error('s1 must have feedback outputs defined');end
   if isempty(fb2.i_idx);error('s2 must have feedback inputs defined');end
   if isempty(fb2.o_idx);error('s2 must have feedback outputs defined');end
   fb1.i_idx = full(fb1.i_idx);
   fb1.o_idx = full(fb1.o_idx);
   fb2.i_idx = full(fb2.i_idx);
   fb2.o_idx = full(fb2.o_idx);
   fb1.ri_idx = full(fb1.ri_idx);
   fb1.ro_idx = full(fb1.ro_idx);
   fb2.ri_idx = full(fb2.ri_idx);
   fb2.ro_idx = full(fb2.ro_idx);
   %set up additional input and output matrices
   [s1out,s1in]=size(s1.d);
   [s2out,s2in]=size(s2.d);
   % form permutation matrices for inputs and outputs
   
   %feedback inputs
   n1fi = fb1.NumInputs;% number of feed back inputs in s1
   n1fo = fb1.NumOutputs;% number of feed back outputs of s1
   p21i = sparse(zeros(s1in,s2out));
   p21i(fb1.i_idx,fb2.o_idx)=eye(n1fi);
   p12i = sparse(zeros(s2in,s1out));
   p12i(fb2.i_idx,fb1.o_idx)=eye(n1fo);
   %retained inputs s1
   if ~isempty(fb1.ri_idx)
      n1ri = length(fb1.ri_idx);% number of retained inputs s1
      p1i = sparse(zeros(s1in,n1ri));
      p1i(fb1.ri_idx,:)=eye(n1ri);
      in1 = [1:n1ri;fb1.ri_idx]';
   else
      % no retained inputs
      n1ri=0;
      in1 = [];
      p1i=[];
   end
   %retained outputs s1
   if ~isempty(fb1.ro_idx)
      n1ro = length(fb1.ro_idx); % number of retained outputs s1
      p1o = sparse(zeros(n1ro,s1out));
      p1o(:,fb1.ro_idx)=eye(n1ro);
      out1 = [1:n1ro;fb1.ro_idx]';
   else
      n1ro=0;
      out1 =[];
      p1o=[];
   end
   %retained inputs s2
   if ~isempty(fb2.ri_idx)
      n2ri = length(fb2.ri_idx);% number of retained inputs s2
      p2i = sparse(zeros(s2in,n2ri));
      p2i(fb2.ri_idx,:)=eye(n2ri);
      in2 = [1:n2ri;fb2.ri_idx]';
   else
      % no retained inputs
      n2ri=0;
      in2=[];
      p2i=[];
   end
   %retained outputs s2
   if ~isempty(fb2.ro_idx)
      n2ro = length(fb2.ro_idx);% number of retained outputs s2
      p2o = sparse(zeros(n2ro,s2out));
      p2o(:,fb2.ro_idx)=eye(n2ro);
      out2 = [1:n2ro;fb2.ro_idx]';
   else
      n2ro=0;
      out2 = [];
   end
   %form transformation matrix for feedback
   nc = s1out+s2out;% total outputs
   nu = s1in+s2in;% total inputs
   nri = n1ri+n2ri;% number of retained inputs
   nro = n1ro+n2ro;% number of retained outputs
   
   cy=sparse(eye(nc));
   cy(1:s1out,s1out+1:nc)=-s1.d*p21i; 
   cy(s1out+1:nc,1:s1out)=-s2.d*p12i;
   icy = inv(cy);
   
   % form transformation matrix for feed forward
   dy = sparse(zeros(nc,nri));
   pi = sparse(zeros(nu,nri));
   if n1ri~=0
      dy(1:s1out,1:n1ri)=s1.d*p1i;
      pi(1:s1in,1:n1ri) = p1i;
   end
   if n2ri~=0
      dy(s1out+1:nc,n1ri+1:nri)=s2.d*p2i;
      pi(s1in+1:nu,n1ri+1:nri)=p2i;
   end
   py = sparse(zeros(nu,nc));
   py(1:s1in,s1out+1:nc)=p21i;
   py(s1in+1:nu,1:s1out)=p12i;
   po = sparse(zeros(nro,nc));
   if n1ro~=0
      po(1:n1ro,fb1.ro_idx)=eye(n1ro);
   end
   if n2ro~=0
      po(n1ro+1:nro,s1out+fb2.ro_idx)=eye(n2ro);
   end
   % form state matrices
   s = sparse([s1;s2]);
   da = icy*dy;
   if ~isempty(s.c)
      ca = icy*s.c;
      c = po*ca;
      if ~isempty(s.b)
         b = s.b*(pi+py*da);
         a = s.a + s.b*py*ca;
      else
         b = sparse([]);
         a = s.a;
      end
   else
      c = sparse([]);
      b = sparse([]);
      a = s.a;
   end
   d = po*da;
   % form state space object
   if ~issparse(s1.a)&&~issparse(s2.a)
      sfba = stsp(full(a),full(b),full(c),full(d));
   else
      sfba = stsp(a,b,c,d);
   end
end   



