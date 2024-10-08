function [flslip,fleff,flpf,flt,stc,stt,eflag]=perfsc(rs,xs,Xm,rr,xr,nll,isat)
% finds the performance specification given equivalent circuit parameters
% inputs:
%   rs      -   stator resistance PU
%   xs      -   stator leakage reactance PU
%   Xm      -   Magnetizing reactance PU
%   rr      -   rotor resitance PU
%   xr      -   rotor leakage reactance PU
%   nll     -   no load loss PU
%   isat    -   PU current at which leakage inductances begin to saturate
%   PU is on the motor MVA base
% outputs:
%   flslip  -   full load slip
%   fleff   -   full load efficiency
%   flpf    -   full load power factor
%   flt     -   full load torque PU
%   stc     -   starting current PU
%   stt     -   starting torque/full load torque
%   eflag   -   0 no error
%           -   1 starting error
%           -   2 full load error
%           -   3 both starting and full load in error

% Graham Rogers January 2003
% copyright Cherry Tree Scientific Software 2003
% All rights reserved
eflag = 0;
switch nargin
case {1 ,2,3,4}
    uiwait(msgbox('all equivalent circuit parameters must be supplied','perfsc error','modal'));
    flslip = [];
    fleff = [];
    flpf = [];
    flt = [];
    stc = [];
    stt = [];
    eflag = 3;
    return
case 5
    nll = 0; 
    isat = 10;
end
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,1,isat);    
stc = abs(nll+1/(zr+i*zi));
stt = ir1*ir1*rr;
% full load
X=1;
y = 1;n_it = 0;
while (abs(y)>1e-12)&&(n_it<30)
    n_it = n_it +1;
    [zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,rr/X,isat);    
    is = nll+1/(zr+i*zi);
    y = abs(is)-1;
    [zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,rr/(X+1e-6),isat); 
    is1 = nll+1/(zr+i*zi);
    J = 1e6*(abs(is1)-abs(is));
    X = X - y/J;
end
flslip = rr/X;
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,1,flslip,isat); 
is = nll + 1/(zr+i*zi);
flpf = cos(angle(is));
flt = ir1*ir1*rr/flslip;
fleff = flt*(1-flslip)/real(is);
stt = stt/flt;
    