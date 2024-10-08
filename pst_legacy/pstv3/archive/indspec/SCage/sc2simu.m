function [xff,mcurr,xslow,te,tes,tff,ts]= sc2simu(V,f,tfr,tld,rs,xs,Xm,rr,xr,isat,H,tsim);
% syntax: [xff,mcurr,xslow,te,tes,tff,ts]= db2simu(V,f,tfr,tld,rs,xs,Xm,rr,xr,isat,H,tsim);
% simulates a single cage induction motor starting from a constant voltage
% source
% Inputs
% V     -   Voltage magnitude PU on motor base
% f     -   supply frequency Hz
% tfr   -   stiction load coefficient PU
% tld   -   load coeeficient PU
%           motor load is tfr*s+tld(1-s_*(1-s)
% rs    -   stator resistance PU
% xs    -   stator leakage reactance PU
% Xm    -   magnetizing reactance PU
% rr    -   rotor resistance PU 
% xr    -   rotor leakage reactance PU
% isat  -   current PU at which leakage reactances begin to saturate
% H     -   inertial constant of motor and load
% tsim  -   simulation time s
%Outputs
% xff   -   stator and rotor flux linkages at the fast sampling rate
% mcurr -   currents in Kron's model at the fast sampling rate
% xslow -   slip at the slow sampling rate
% te    -   torque at the fast sampling rate
% tes   -   torque at the slow samping rate
% tff   -   time at fast sampling rate
% ts    -   time at slow sampling rate
% The motor parameters may be obtained by running calcdc
% requires the stsp class

% January 31, 2003
% Author Graham Rogers
% Copyright Cherry Tree Scientific Software 1993-2003 - All Rights Reserved

xss=xs;xrs=xr;
w=2*pi*f;
hslow = 0.25/f;
tsim = floor(tsim/hslow)*hslow;
ts = 0:hslow:tsim;
tf = 0:1/20/f:hslow;
bs = [0;V;0;0];
xff = [];%fast states
tff = [];
xfast = zeros(4,length(tf));xfend=zeros(4,1);
xslow = zeros(1,length(ts));%slow states
te = [];
xslow(1) = 1;
nf=length(tf);
ns=0;tflast = 0;
tes = zeros(1,length(ts));
% calculates the saturated values of the rotor leakage reactances at start
[zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,V,1,isat);
Xr = xrs+Xm;Xs = xss+Xm;
Xsp = xss+xrs*Xm/(xrs+Xm);
Xrp = xrs+xss*Xm/(xss+Xm);
mcurr = [];
while ns<length(ts)-1
    ns = ns+1;
    IXmat = [Xr  0 -Xm 0;0 Xr 0 -Xm;-Xm 0 Xs 0;0 -Xm 0 Xr]/(Xr*Xs-Xm*Xm);
    as = rs/Xsp;asr = as*Xm/Xr;
    ar = rr/Xrp;ars = ar*Xm/Xs;
    tcoef = w*w*Xm/Xr/(Xs-Xm*Xm/Xr);
    asmat = zeros(4);
    asmat = w*[-as 1 asr 0 ;-1 -as  0 asr ;ars  0 -ar  xslow(ns) ; 0 ars -xslow(ns) -ar];
    sm = stsp(asmat,bs,eye(4),zeros(4,1));% forms stsp object for fast states
    [xfast,tf,xfend] = response(sm,1,tf,xfend);% solves for fast states
    mcurr = [mcurr w*IXmat*xfast];
    tff = [tff tflast+tf];tflast = max(tff);
    xff = [xff xfast];
    tef = tcoef*(xfast(2,:).*xfast(3,:)-xfast(1,:).*xfast(4,:));
    tes(ns) = mean(tef);
    te = [te tef]; 
    xslow(ns+1) = xslow(ns)+ hslow*(tfr*xslow(ns)+tld*(1-xslow(ns)*xslow(ns)) - tes(ns))/2/H;% updates slip
    % calculates saturated values od leakage reactances assuming steady
    % state
    [zr,zi,xss,xrs,is1,ir1,eflag]=zsc(rs,xs,Xm,xr,rr,V,abs(xslow(ns+1)),isat);
    Xr = xrs+Xm;Xs = xss+Xm;
    Xsp = xss + xrs*Xm/(xrs+Xm);
    Xrp = xrs + xss*Xm/(xss+Xm);
end
tes(ns+1)=tes(ns);
return
