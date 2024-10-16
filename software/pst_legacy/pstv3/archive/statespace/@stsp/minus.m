function st = minus(s1,s2)
%subtracts the outputs of two state space objects and creates a new state space object
%syntax st = minus(s1,s2)
%inputs two state space objects with the same number of ouputs
%output a new state space object representing the difference

if (~isa(s1,'stsp')||~isa(s2,'stsp'))
   error('s1 and s2 must be state space objects')
else
   % check number of outputs
   if s1.NumOutputs~=s2.NumOutputs
      error('the number of outputs in s1 and s2 must be equal')
   end
   no = s1.NumOutputs;
   ni = s1.NumInputs + s2.NumInputs;
   ns = s1.NumStates + s2.NumStates;
   a=zeros(ns);
   n1=s1.NumStates;
   a(1:n1,1:n1)=s1.a;
   a(n1+1:ns,n1+1:ns)=s2.a;
   b = zeros(ns,ni);
   b(1:n1,1:s1.NumInputs)=s1.b;
   b(1+n1:ns,1+s1.NumInputs:ni)=s2.b;
   c = zeros(no,ns);
   c(1:no,1:n1)=s1.c;
   c(1:no,n1+1:ns) = - s2.c;
   d=zeros(no,ni);
   d(1:no,1:s1.NumInputs)=s1.d;
   d(1:no,1+s1.NumInputs:ni)= - s2.d;
   st=stsp(a,b,c,d);
end
