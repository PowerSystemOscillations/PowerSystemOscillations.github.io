function sred = reduss(s,k);
% balanced residual reduction of an unstable system 
% retains k states in the stable part
% based on 
% - Table 11.30 Skogestad and Postlewhwaite, 'Multivariable Feedback Control', John Wiley and Sons
% convert to sys

[sss,ssu]=sdecomp(s);
sss = sysbal(sss);
s1 = sresid(sss,k);
sred = s1+ssu;
nis1=s1.NumInputs;
sred = sum_in(sred,1:nis1,nis1+1:2*nis1);

