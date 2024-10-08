function [flslip,fleff,flpf,flt,stc,stt,eflag]=perfdb(rs,xs,Xm,rr,xr,dbf,nll,isat)
% finds the performance specification given equivalent circuit parameters
% inputs:
%   rs       -   stator resistance PU
%   xs       -   stator leakage reactance PU
%   Xm       -   Magnetizing reactance PU
%   rr1      -   rotor resitance PU
%   xr1      -   rotor leakage reactance PU
%   dbf      -   deepbar factor   
%   isat     -   PU current at which leakage inductances begin to saturate
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
case {1 ,2,3,4,5}
    uiwait(msgbox('all equivalent circuit parameters must be supplied','perfsc error','modal'));
    flslip = [];
    fleff = [];
    flpf = [];
    flt = [];
    stc = [];
    stt = [];
    eflag = 3;
    return
case 6
    isat = 10;
end   
[zr,zi,xss,xrs,rre,xre,is,ir,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,1,isat);
stc = abs(nll+1/(zr+i*zi));stt = ir*conj(ir)*rre;
if eflag
    uiwait(msgbox('starting iteration failed','perfdc error','modal'))
    stc = [];stt=[];
end
% full load

phi = 0; X=1;
y = 1;n_it = 0;
x = 0.01;
while (abs(y)>1e-8)&&(n_it<30)
    n_it = n_it +1;
    [zr,zi,xss,xrs,rre,xre,is,ir,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,x,isat);
    is = nll+1/(zr+i*zi);
    x1 = x+1e-6;
    [zr,zi,xss,xrs,rre,xre,is1,ir1,eflag]=zdb(rs,xs,Xm,xr,rr,dbf,1,x1,isat);
    is1 = nll+1/(zr+i*zi);
    y = abs(is)-1;
    Jc = (abs(is)-abs(is1))*1e6;
    x = x -y/Jc;
end
if n_it>30
    eflag = eflag+2;
    uiwait(msgbox('full load iteration failed to converge','perfdc error','modal'))
    flslip = [];flpf = [];flt = []; fleff = [];
    return
end
flslip = x ;
flpf = cos(angle(is));
flt = ir*conj(ir)*rre/flslip;
fleff = flt*(1-flslip)/flpf;
stt = stt/flt;
    