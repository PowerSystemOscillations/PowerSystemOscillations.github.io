function si=int_stsp(K);
% si = K/s
%syntax si = int_stsp(K)
% if K is a vector, si is a stacked state space object
%integrator state space object with gain K

% (c) copyright Cherry Tree Scientific Software 1997-1999
% All rights reserved

if nargin==0;K=1;end
ns = length(K);
si = stsp(zeros(ns),diag(K),eye(ns),zeros(ns));