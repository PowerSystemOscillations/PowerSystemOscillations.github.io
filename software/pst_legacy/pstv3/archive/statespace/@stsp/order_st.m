function [sm,e_flag] = order_st(s,x_idx);
% reorders the states of a state space object
%syntax sm = order_st(s,x_idx)
% inputs  s - state space object
%         x_idx - index of state order required in new state space object
% output  sm - modified state space object

%author - Graham Rogers
%date - October 1999
% (c) - copyright Cherry Tree Scientific Software 1999

if nargin ~=2
   uiwait(msgbox('both inputs must be defined','order_st error','modal'));
   sm = stsp;e_flag = 1;
   return
elseif ~isa(s,'stsp')
   uiwait(msgbox('s must be a state space object','order_st error','modal'));
   sm = stsp;e_flag = 1;
   return
else
   if length(x_idx)~=s.NumStates
      uiwait(msgbox('the index must be of length equal to the number of states','order_st error','modal'));
      sm = stsp;e_flag = 1;
      return
   else
      e_flag = 0;
      a = s.a(x_idx,x_idx);
      b=s.b(x_idx,:);
      c = s.c(:,x_idx);
      d=s.d;
   end
   sm = stsp(a,b,c,d);
end

   