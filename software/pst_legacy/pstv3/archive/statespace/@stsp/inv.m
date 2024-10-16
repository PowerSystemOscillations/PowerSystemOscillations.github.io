function si = inv(s)
%finds inverse of a state space system
% syntax:  si=inv(s)

if ~isa(s,'stsp')
   error(' must be a state space object')
else
   %test for inverse
   if isempty(s.d)
      error('s.d must not be empty')
   elseif s.NumInputs~=s.NumOutputs
      error('s.d must be square')
   else
      dcn = cond(s.d);
      if dcn>1e10
         warning('s.d almost singular')
      end
      d=inv(s.d);
      a=s.a-s.b*d*s.c;b=s.b*d;c=-d*s.c;
      si=stsp(a,b,c,d);
   end
end
   