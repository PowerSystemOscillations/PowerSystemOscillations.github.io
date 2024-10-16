function [sm,e_flag] = order_out(s,c_idx)
% reorders the outputs of a state space object
%syntax sm = order_out(s,c_idx)
% inputs  s - state space object
%         c_idx - index of outputs required in new state space object
% output  sm - modified state space object

%author - Graham Rogers
%date - May 1999
% (c) - copyright Cherry Tree Scientific Software

if nargin ~=2
   uiwait(msgbox('both inputs must be defined','order_out error','modal'));
   sm = stsp;e_flag = 1;
   return
elseif ~isa(s,'stsp')
   uiwait(msgbox('s must be a state space matrix','order_out error','modal'));
   sm = stsp;e_flag = 1;
   return
else
   a=s.a;b=s.b;
   if length(c_idx)~=s.NumOutputs
     uiwait(msgbox('inconsistent index','order_out error','modal'));
     sm = stsp;e_flag = 1;
     return
   else
      c=s.c(c_idx,:);
      d=s.d(c_idx,:);
   end
   sm = stsp(a,b,c,d);e_flag=0;
end

   