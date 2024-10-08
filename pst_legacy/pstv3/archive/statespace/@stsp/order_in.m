function [sm,e_flag] = order_in(s,b_idx)
% reorders the inputs of a state space object
%syntax sm = order_in(s,b_idx)
% inputs  s - state space object
%         b_idx - index of inputs required in new state space object
% output  sm - modified state space object

%author - Graham Rogers
%date - May 1999
% (c) - copyright Cherry Tree Scientific Software 1999-2005

if nargin ~=2
   uiwait(msgbox('both inputs must be defined','order_in error','modal'));
   sm = stsp;e_flag = 1;
   return
elseif ~isa(s,'stsp')
   uiwait(msgbox('s must be a state space object','order_in error','modal'));
   sm = stsp;e_flag = 1;
   return
else
   a=s.a;c=s.c;
   if length(b_idx)~=s.NumInputs
      uiwait(msgbox('inconsistent index','order_in error','modal'));
      sm = stsp;e_flag = 1;
      return
   else
      if ~isempty(s.b);b=s.b(:,b_idx);else b=[];end
      d=s.d(:,b_idx);
   end
   sm = stsp(a,b,c,d);
end

   