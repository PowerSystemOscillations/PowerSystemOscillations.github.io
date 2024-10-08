function st = transpose(s)
%transpose of a state space object
%syntax st = transpose(s)
%or
%       st = s.'
%transpose of a state space object
%st.a=s.a.'
%st.b = s.c'
%st.c = st.b'
%st.d = s.d'

%Author: Graham Rogers
%Date:   August 1998
%(c) Copyright Cherry Tree Scientific Software 1998

if ~isa(s,'stsp')
   error('s must be a state space object')
else
   a = s.a.';b=s.c.';c=s.b.';d=s.d.';
   st = stsp(a,b,c,d);
end