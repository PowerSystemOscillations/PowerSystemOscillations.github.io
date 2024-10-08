function [st,in1,in2,out1,out2] = times(s1,s2,n_ic,ico_idx,ici_idx)
% vector multiplication for state space objects
%syntax [st,in1,in2,out1,out2] = times(s1,s2,n_ic,ico_idx,ici_idx)
%inputs 
%      s1 and s2 state space objects
%      n_ic = number of interconnections
%      ico_idx index of the outputs of s1 to be connected to s2
%      ici_idx index of the inputs of s2 to be interconnected
%     
% outputs
%      st a state space object with 
%                   output equal to output of s2 and any outputs of s1 not interconnected
%                   output order : retained outputs of s1;outputs of s2
%                   input equal to the input of s1 and the inputs of s2 not interconnected
%                   input order :  inputs of s1; retained inputs of s2
%      in1 - correspondence between inputs to st and inputs to s1
%      in2 - correspondence between inputs to st and inputs to s2
%      out1 - correspondence between outputs of st and outputs of s1
%      out2 - correspondence between outputs of st and outputs of s2

if ~isa(s1,'stsp')&&~isa(s2,'stsp')
   error('s1 or s2 must be a state space object')
elseif ~isa(s1,'stsp')
   [rs1,cs1]=size(s1);
   if ((rs1==1)&&(cs1==1))
      %s1 is a scalar, convert to a state space object
      s1 = stsp([],[],[],s1*eye(s2.NumInputs));
      if issparse(s2.a);s1=sparse(s1);end
   else
      error('s1 must be a scalar or a state space object')
   end
elseif ~isa(s2,'stsp')
   if size(s2)==[1 1]&&s2~=0
      %s2 is a scalar, convert to a state space object
      s2 = stsp([],[],[],s2*eye(s1.NumOutputs));
      if issparse(s1.a);s2=sparse(s2);end
   else
      error('s2 must be a scalar or a state space object')
   end
end
if nargin==2
   if s1.NumOutputs~=s2.NumInputs
      error('the number of outputs of s1 must equal the number of inputs of s2')
   end
   ns = s1.NumStates+s2.NumStates;
   no=s2.NumOutputs;
   ni = s1.NumInputs;
   a=sparse(zeros(ns));
   b = sparse(zeros(ns,ni));
   c= sparse(zeros(no,ns));
   d=sparse(zeros(no,ni));
   if s1.NumStates~=0;
      a(1:s1.NumStates,1:s1.NumStates)=s1.a;
      b(1:s1.NumStates,1:ni)=s1.b;
      c(1:no,1:s1.NumStates)=s2.d*s1.c;
   end
   if s2.NumStates~=0;
      a(s1.NumStates+1:ns,s1.NumStates+1:ns)=s2.a;
      c(1:no,s1.NumStates+1:ns)=s2.c;
      b(s1.NumStates+1:ns,1:ni)= s2.b*s1.d;
      if s1.NumStates~=0;
         a(s1.NumStates+1:ns,1:s1.NumStates)=s2.b*s1.c;
      end
   end
   d(1:no,1:ni)=s2.d*s1.d;
   if ~issparse(s1.a)&&~issparse(s2.a)
      st = stsp(full(a),full(b),full(c),full(d));
   else
      st = stsp(a,b,c,d);
   end
   return
end
if nargin~=5
   error('all indices must be specified for general multiplication')
elseif length(n_ic)~=[1 1];
    error('n_ic must be a scalar')
elseif (length(ico_idx)~=n_ic)||(length(ici_idx)~=n_ic)
   error('interconnection indexes inconsistent')
elseif n_ic>s1.NumOutputs
   error('the number of interconnections must be <= the number of outputs of s1')
elseif n_ic>s2.NumInputs
   error('the number of interconnections must be <= the number of inputs of s2')
elseif max(ico_idx)>s1.NumOutputs
   error('output index out-of-range')
elseif max(ici_idx)>s2.NumInputs
   error('input index out-of-range')
else  
   ns1 = s1.NumStates;ns2 = s2.NumStates;
   ns = ns1+ns2;
   s1out = s1.NumOutputs;
   s1in = s1.NumInputs;
   s2out = s2.NumOutputs;
   s2in = s2.NumInputs;
   no1 = s1out - n_ic;
   no=s2out + no1;
   ni2 = s2in - n_ic;
   ni = s1in+ni2;
   in1 = [1:s1in]';
   out2 = [1+no1:s2out+no1]';
   if no1~=0
      out1i = zeros(1,s1out);out1i(ico_idx)=ones(1,n_ic);
      s1o_idx = find(out1i==0);
      out1 = [s1o_idx;1:no1]';
   else
      out1 =[];
   end
   if ni2~=0
      in2i = zeros(1,s2in);in2i(ici_idx)=ones(1,n_ic);
      s2i_idx = find(in2i==0);
      in2 = [s2i_idx]';
   else
      in2 = [];
   end
   a=sparse(zeros(ns));
   b =sparse( zeros(ns,ni));
   c= sparse(zeros(no,ns));
   d=sparse(zeros(no,ni));
   %form interconnection perturbation matrices
   pm1 = sparse(zeros(n_ic,s1out));
   pm1(1:n_ic,ico_idx)=sparse(eye(n_ic));
   pm1o = sparse(eye(s1out));
   pm1o(ico_idx,:)= [];
   pm2 = sparse(zeros(s2in,n_ic));
   pm2(ici_idx,1:n_ic)=sparse(eye(n_ic));
   pm2i = sparse(eye(s2in));
   pm2i(:,ici_idx)=[];
   %form interconnected state matrix
   if ns1~=0;
      a(1:ns1,1:ns1)=s1.a;
      b(1:ns1,1:s1in)=s1.b;
      c(1+no1:no,1:ns1)=s2.d*pm2*pm1*s1.c;
      if no1~=0;c(1:no1,1:ns1) = pm1o*s1.c;end
   end
   if ns2~=0;
      a(ns1+1:ns,ns1+1:ns)=s2.a;
      b(1+ns1:ns,1+s1in:ni)=s2.b*pm2i;
      c(1+no1:no,ns1+1:ns)=s2.c;
      b(ns1+1:ns,1:s1in)= s2.b*pm2*pm1*s1.d;
      if ns1~=0;
         a(ns1+1:ns,1:ns1)=s2.b*pm2*pm1*s1.c;
      end
   end
   d(1+no1:no,1:s1in)=s2.d*pm2*pm1*s1.d;
   d(1+no1:no,1+s1in:ni)=s2.d*pm2i;
   if no1~=0; d(1:no1,1:s1in) = pm1o*s1.d;end
   if ~issparse(s1.a)&&~issparse(s2.a)
      st = stsp(full(a),full(b),full(c),full(d));
   else
      st = stsp(a,b,c,d);
   end
end