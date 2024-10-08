function si=combine_in(s,s1_idx,s2_idx,r_idx)
%sums selected inputs and retains selected inputs
%syntax: si=sum_in(s,s1_idx,s2_idx,r_idx)
% inputs  s state space object
%         s1_idx - index of the first inputs to be summed
%         s2_idx - index of the second inputs to be summed
%                  s1_idx and s2_idx must have the same length
%          - if an entry is negative the corresponding input will be subtracted
%         r_idx - index of inputs of s to be retained
% output  si - modified state space object 
%              the summed inputs are the first inputs of si
%              the retained inputs follow in the order of r_idx
%              outputs are unchanged

%Author: Graham Rogers
%date : November 1999
% copyright (c) Cherry Tree Scientific Software 1999

if ~isa(s,'stsp')
   error('s must be a state space object')
elseif max(abs(s1_idx))>s.NumInputs||max(abs(s2_idx))>s.NumInputs
   error('the summing indeces are too large')
else
   if(nargin==3)
      % retain all other inputs is default
      r_idx = ones(1,s.NumInputs);
      us_idx = union(s1_idx,s2_idx);
      r_idx(us_idx) = zeros(1,length(us_idx));
      r_idx=find(r_idx==1);
   elseif ~isempty(r_idx)
      if max(r_idx)>s.NumInputs
         error('the retained index is to large')
      end
   end
   if(nargin==1);warning('s will be unchanged');si=s;return;end
   a=s.a;c=s.c;
   if ~isempty(s.b)
        bs = s.b(:,abs(s1_idx))*diag(sign(s1_idx))+s.b(:,abs(s2_idx))*diag(sign(s2_idx));
        br = s.b(:,r_idx);
        b = [bs br];
    else
        b=[];
    end
   ds = s.d(:,abs(s1_idx))*diag(sign(s1_idx))+s.d(:,abs(s2_idx))*diag(sign(s2_idx));
   dr = s.d(:,r_idx);
   d = [ds dr];
   si = stsp(a,b,c,d);
end

   
      
      
