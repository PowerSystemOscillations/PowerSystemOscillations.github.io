function sa=add_in(s,b,d)
%appends additional inputs to a state space object
%syntax: sa=add_in(s,b,d)
%inputs s - original state space object
%       b - additional input matrix; must have rows equal to the number of states in s
%       d - additional d matrix; must have number of rows equal to number of outputs, and columns equal to number of columns of b
%       if b is empty  the original input  matrix is unaltered
%       if d is  empty the original d is augmented by zeros to be consistent with the new b and c matrices
%output sa - new state space object with added inputs following the original inputs 

%author: Graham Rogers
%date: May 1999
% (c) copyright  Cherry Tree Scientific Software 1999

if nargin~=3
   error('you must specify all inputs')
elseif ~isa(s,'stsp')
   error('the first input must be a state space object')
else
   NumStates = s.NumStates;
   NumOutputs = s.NumOutputs;
   if ~isempty(b)
      [ri,ci]=size(b);
      if ri~=NumStates
         error('the number of rows of b must equal the number of states of s')
      else
         ba = [s.b b];
      end
   else
      ba = s.b;
      ci = 0;
   end
   ca = s.c;  
   if ~isempty(d)
       [rd,cd]=size(d);
      if (rd==NumOutputs&&cd==ci)||ci==0
         da=  [s.d d];
      else
         error('d not consistent')
      end
   else
      da = [s.d zeros(NumOutputs,ci)];
   end

   sa=stsp(s.a,ba,ca,da);
end

