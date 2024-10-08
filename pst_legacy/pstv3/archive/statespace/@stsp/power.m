function sp = power(s,b)
%overloads the power function for state space objects
%syntax: sp = power(s,b), or sp = s.^b
% examples 
%         s.^2 is equivalent to s.*s
%         s.^-1 is equivalent to s = inv(s) - for invertable systems only (d non-singular)
%         s.^-2 is equivalent to s = inv(s);s=s.*s 
%         s.^0 is equivalent to sp = stsp([],[],[],eye(s.NumOutputs)) - for square systems only

% November 1999
% Author: Graham Rogers
%(c) copyright Cherry Tree Scientific Software 1999

if nargin == 0
   error('you must at least specify a state space object')
elseif nargin==1
   b = 1;
end

% change b to integer 
b = fix(b);
if b>0
   sp = s;
   if b>1
      k=1;
      while k <b 
         k=k+1;
         sp = sp.*s;
      end
   end
elseif b == 0
   % check that s is square
   if s.NumInputs~=s.NumOutputs
      error(' s is not square')
   else
      sp = stsp([],[],[],eye(s.NumOutputs));
   end
elseif b<0
   % check that system is invertible
   if cond(s.d)< 1e-9
      error('s cannot be inverted - d is singular')
   else
      b = abs(b);
      sp = inv(s);s = sp;
      if b>1
         k=1;
         while k <b 
            k=k+1;
            sp = sp.*s;
         end
      end
   end
end
   
