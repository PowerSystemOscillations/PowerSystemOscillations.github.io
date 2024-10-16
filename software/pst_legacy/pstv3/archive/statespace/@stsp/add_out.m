function sa=add_out(s,c,d)
%appends additional outputs to a state space object
%syntax: sa=add_io(s,c,d)
%inputs s - original state space object
%       c - additional output matrix; must have number of columns equal to number of states in s
%       d - additional d matrix; must have num of rows equal to number of columns of c, and columns equal to number of columns of b
%       if c is empty the original output matrix is unaltered
%       if d is an empty matrix the original d is augmented by zeros to be consistent with the new c matrices
%output sa - new state space object with added inputs and outputs following the original inputs and outputs

%author: Graham Rogers
%date: May 1999
% (c) copyright  Cherry Tree Scientific Software 1999

if nargin~=3
   error('you must specify all inputs')
elseif ~isa(s,'stsp')
   error('the first input must be a state space object')
else
   NumStates = s.NumStates;
   ba = s.b;
   if ~isempty(c)
      [rc,co]=size(c);
      if co~=NumStates
         error('the number of columns of c must equal the number of states of s')
      else
         ca = [s.c ; c];
      end
   else
      ca = s.c;rc=0;
   end
   if ~isempty(d)
      [rd,co] = size(d);
      if rd~=rc&&~isempty(c)
          error('d outputs not consistent in add_out')
      elseif co ~=s.NumInputs
            error('d inputs not consistent in add_out')
      end
      da = [s.d ; d];
  else
      da = [s.d; zeros(rc,s.NumInputs)];
  end
   sa=stsp(s.a,ba,ca,da);
end

