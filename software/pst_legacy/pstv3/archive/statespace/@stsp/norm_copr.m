function  [sn,sm]=norm_copr(s)
% forms the normalized coprime factors of the state space object s
%based on Table 4.1 Multivariable Feedback Control, Skogestad and Postlethwaite, John Wiley and Sons, 1995
ni = s.NumInputs;
no =s.NumOutputs;
ns = s.NumStates;
S=eye(ni)+s.d'*s.d;
R = eye(no)+s.d*s.d';
q = S\[s.d' s.b'];
A1 = s.a -s.b*q(:,1:no)*s.c;
R1 = s.c'*(R\s.c);
Q1 = s.b*q(:,no+1:no+ni)*s.b';
[z1,z2,fail,reig_min]=ric_schr([A1' -R1;-Q1 -A1]);
z=z2/z1;
H=-(s.b*s.d' +z*s.c')*inv(R);
A = s.a+H*s.c;
dm = sqrt(R);
cd = dm\[s.c s.d];
bn = s.b +H*s.d;
cn = cd(:,1:ns);
dn = cd(:,ns+1:(ns+ni));
sn = stsp(A,bn,cn,dn);
sm = stsp(A,H,cn,dm);

