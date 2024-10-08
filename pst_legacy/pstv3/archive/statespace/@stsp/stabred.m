function sred = stabred(s,k)
% balanced residual reduction of a stable system
% syntax:sred = stabred(s,k)
% inputs
%        s - state space object to be reduced
%        k - number of retained states
% output sred  - reduced stste space object
% requires mu-analysis and synthesis toolbox
% Author: Graham Rogers
% Date: August 1998


[sysb,hsig]=sysbal(s);
sred = sresid(sysb,k);
