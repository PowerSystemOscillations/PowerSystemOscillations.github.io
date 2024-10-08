function  rl = rtlocus(sf,sb,gmin,gstep,gmax,flag)
% calculates the root locus of two state space objects
% s1 is the forward loop
% s2 is the positive feedback
% for the rootlocus is calculated for the gain gmin:gstep:gmax
% if flag == 1: the gain multiplies sb
% if flag = 2: the gain multiplies sf
if nargin<5
   error('rtlocus error, there must be at least 5 inputs')
end
if nargin==5
   flag = 1;
   %feedback gain varies
end
notsf=0;
if ~isa(sf,'stsp')
   notsf=1;
   %must be a scalar gain matrix
   if -isa(sb,'stsp')
      error('sb must be a state space object if sf is a scalar')
   elseif isempty(sb.a)
      error('either sf or sb must be dynamic')
   end
   sf = stsp([],[],[],sf);
end
if ~isa(sb,'stsp')
   %must be a scalar feedback matrix
   if notsf==1
      error('sf must be a state space object if sb is a scalar')
   elseif isempty(sf.a)
      error('either sf or sb must be dynamic')
   end
   sb = stsp([],[],[],sb);
end
%check consistency
if sf.NumOutputs~=sb.NumInputs
   error('the number of outputs of sf must equal the number of inputs of sb')
end
if sf.NumInputs~=sb.NumOutputs
   error('the number of inputs of sf must equal the number of outputs of sb')
end
if flag==1
   bo = sb.b;
   do = sb.d;
elseif flag==2
   bo = sf.b;
   do = sf.d;
end
k=0;  
nsteps = round((gmax-gmin)/gstep);
nst = sf.NumStates + sb.NumStates;
rl=zeros(nst,nsteps);
for gain = gmin:gstep:gmax
   k=k+1;
   if flag==1
      sb.b = bo*gain;
      sb.d = do*gain;
   elseif flag ==2
      sf.b = bo*gain;
      sf.d = do*gain;
   end
   s=fb_aug(sf,sb);
   l=eig(s.a);
   rl(:,k) = sort(l);
end
