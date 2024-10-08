function [sc,gmin]=cpc_stsp(s,grel);
% Finds a robust controller based on co-prime uncertainty
% syntax: [sc,gmin] = cpc_stsp(s,grel)
% inputs: s the stsp object to be controlled
%         grel weighting on gamma, typically 1.1
% output: a robust stabilizing positive feedback controller
% modified from coprimeunc 
% - Table 9.2 Skogestad and Postlewhwaite, 'Multivariable Feedback Control', John Wiley and Sons

if ~isa(s,'stsp');error('s must be a state space object');end
if nargin == 1;grel=1.1;end
S = eye(s.NumInputs)+s.d'*s.d;
R = eye(s.NumOutputs) + s.d*s.d';
a1 = s.a-s.b*(S\s.d')*s.c;
q1 = s.c'*(R\s.c);
r1 = (s.b/S)*s.b';
a2 = s.a - s.b*(s.d'/R)*s.c;
q2 = s.b*(S\s.b');
r2 = s.c'*(R\s.c);
[x1,x2,fail,reig_min]=ric_schr([a1 -r1;-q1 -a1']);
if fail==1;error('the hamiltonian matrix has an imaginary eigenvalue');end
if fail==2;error('the hamiltonian matrix has an unequal number of positive and negative eigenvalues');end
if fail==3;error('the number of pos and neg eigenvalues is not the same and there is an imaginary eigenvalue');end
X = x2/x1;
[x1,x2,fail,reig_min]=ric_schr([a2' -r2;-q2 -a2]);
if fail==1;error('the hamiltonian matrix has an imaginary eigenvalue');end
if fail==2;error('the hamiltonian matrix has an unequal number of positive and negative eigenvalues');end
if fail==3;error('the number of pos and neg eigenvalues is not the same and there is an imaginary eigenvalue');end
Z = x2/x1;
gmin = sqrt(1+max(real(eig(Z*X))));
gam = gmin*grel;gm2 = gam*gam;
In = eye(size(Z*X));
L = In- (In  + Z*X)/gm2;
F = -S\(s.d'*s.c+s.b'*X);
ac = s.a + s.b*F- L\(Z*s.c'*(s.c+s.d*F));
bc = L\(Z*s.c');
cc = -s.b'*X;
dc = -s.d';
sc = stsp(ac,bc,cc,dc);