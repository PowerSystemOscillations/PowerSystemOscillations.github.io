function [spo,xss,xrs,xsps,tpo] = tmax(rs,xs,Xm,rr,xr,V,isat);
% syntax: [spo,tpo] = tmax(rs,xs,Xm,rr,xr,1,isat)
% calculates the pull out slip and torque given a single cage induction
% motor parameters
% Take leakage inductance saturation into account
%Inputs
% rs    -   stator resistance PU
% xs    -   stator leakage reactance PU
% Xm    -   Magnetizing reactance PU
% rr    -   rotor leakage resistance PU
% xr    -   rotor leakage reactance PU
% V     -   stator voltage PU
% isat  -   satutation current PU
%Outputs
% spo   -   pull-out slip
% tpo   -   pull-out torque PU

% December 9, 2002
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2002 - All Rights Reserved

xsp = xs + Xm*xr/(Xm+xr);
spo = (rr/xsp)*sqrt((1+(rs/(xs+Xm))^2)/(1+(rs/xsp)^2));
nsp = 0;spoerr = 1;
while (spoerr>1e-5)&(nsp<10)
    nsp = nsp+1;
    [zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,V,spo,isat);
    xsps = xss + Xm*xrs/(Xm+xrs);
    spo1 = (rr/xsp)*sqrt((1+(rs/(xss+Xm))^2)/(1+(rs/xsps)^2));
    tpo = ir1*ir1*rr/spo1;
    spoerr = abs((spo-spo1)/spo1);
    spo = spo1;
end