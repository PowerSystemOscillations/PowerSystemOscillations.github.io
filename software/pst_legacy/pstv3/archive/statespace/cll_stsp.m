function s = cll_stsp(K,an,bn,ad,bd)
% K(1+an*s+bn*s^2)/(1+ad*s+bd*s^2)
% single input single output complex filter

% (c) copyright Cherry Tree Scientific Software 1997-1999
% All rights reserved

if bd==0
   error('bd must be non zero')
else
   a = [-ad/bd -1/bd;1 0];
   b = [K/bd 0]';
   c = [an-ad*bn/bd 1-bn/bd];
   d = K*bn/bd;
   s = stsp(a,b,c,d);
end