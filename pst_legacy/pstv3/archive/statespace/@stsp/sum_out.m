function so=sum_out(s,s1_idx,s2_idx,r_idx)
%sums selected outputs and retains selected outputs
%syntax: so=sum_out(s,s1_idx,s2_idx,r_idx)
% inputs  s state space object
%         s1_idx - index of the first group outputs to be summed
%         s2-idx - index of the second group of outputs to be summed
%         s1 and s2 must be the same length
%          - if an entry is negative the corresponding output will be subtracted
%         r_idx - index of outputs of s to be retained
% output  so - modified state space object 
%              the summed outputs are the first outputs of so
%              the retained outputs follow in the order of r_idx
%              inputs are unchanged

%Author: Graham Rogers
%date : August 1999
% copyright (c) Cherry Tree Scientific Software 1999

if ~isa(s,'stsp')
    error('s must be a state space object')
elseif max(s1_idx)>s.NumOutputs|max(s2_idx)>s.NumOutputs
    error('the summing index is too large')
elseif length(s1_idx)~=length(s2_idx)
    error('the two summing indexes must be the same length')
else
    if(nargin==3)
        r_idx=[];
    elseif max(r_idx)>s.NumOutputs
        error('the retained index is to large')
    end
    if(nargin==1);warning('s will be unchanged');so=s;return;end
    a=s.a;b=s.b;
    if ~isempty(s.c)
        cs = diag(sign(s1_idx))*s.c(abs(s1_idx),:)+diag(sign(s2_idx))*s.c(abs(s2_idx),:);
        cr = s.c(r_idx,:);
        c = [cs;cr];
    else
        c = [];
    end
    ds = diag(sign(s1_idx))*s.d(abs(s1_idx),:)+diag(sign(s2_idx))*s.d(abs(s2_idx),:);
    dr = s.d(r_idx,:);
    d = [ds;dr];
    so = stsp(a,b,c,d);
end