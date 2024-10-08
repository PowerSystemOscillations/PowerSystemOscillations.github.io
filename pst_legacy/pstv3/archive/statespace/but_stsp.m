function s = but_stsp(fb,n)
% n stage butterworth filter
% single input single output

% (c) copyright Cherry Tree Scientific Software 1997-1999
% All rights reserved

switch nargin
case 0
   error('you must enter the natural frequency of the filter in Hz')
case 1
   wn = 2*pi*fb;
   s = lag_stsp(1,wn);
case 2
   wn = 2*pi*fb;
   if n==1;
      s = lag_stsp(1,1/wn);
   else
      theta = pi/(n+1);
      k = 0;
      s=stsp([],[],[],1);
      thetak = 0;
      while k<fix(n/2)
         k = k+1;
         thetak = thetak+theta;
         s=s.*cll_stsp(1,0,0,2*sin(thetak)/wn,1/wn/wn);
      end
      if n/2>fix(n/2)
         s = s.*lag_stsp(1,1/wn);
      end
   end
end