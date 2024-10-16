function r = residue(s)
% calculates the residues of a state space object
%syntax: r = residue(s)
% r is a cell of residues at each eigenvalue
if ~isa(s,'stsp')
   error('s must be a state space object')
else
   [l,u,v]=eig(s);
   for k=1:s.NumStates
      r(k)={(s.c*u(:,k))*(v(k,:)*s.b)};
   end
end
   
   
   