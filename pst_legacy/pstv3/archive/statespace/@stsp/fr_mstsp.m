% multivariable frequency response
%syntax: [f,y,smn,smx,cn]=fr_mstsp(s,ftype,fstart,fstep,fend)
%calculates frequency response from state space object
% s is a state space object - which must have a non-empty state matrix
% ftype = 'lin' gives a linear set of frequencies
% ftype = 'log' gives a logarithmic range of frequencies
%         in this case fstp is treated as a multiplier - minimum value 1.01
% if fstart, fstep and fend are not entered, ftype must be a vector of frequencies in Hz
% fstart is the start frequency in Hz
% fstep is the frequency step in Hz
% fend is the end frequency in Hz
%
% f is the frequency vector used for plotting
% y is a cell object 
% y{k}(m,n) gives the frequency response of the mth output to the nth input
% smn is the minimum sigular value vector
% smx is the maximum singular value vector
% cn is the condition number vector (smx./smn)


% Author: Graham Rogers
% Date:   September 1994
% Modified September 1996
% Modified January 1998
function [f,y,smn,smx,cn] = fr_mstsp(s,ftype,fstart,fstep,fend)
if ~isa(s,'stsp')
   error('s must be a state space object')
end
if isempty(s.a);error('the state space object is not dynamic');end   
tstate = s.NumStates;
if nargin==2
   f=ftype;
elseif strcmp(ftype,'lin');
   f = fstart:fstep:fend;
elseif strcmp(ftype,'log')
   if fstep<1.01;fstep=1.01;end
   fslog = log(fstart);
   felog = log(fend);
   fstlog = log(fstep);
   flog = fslog:fstlog:felog;
   f = exp(flog);
end
n_fp = length(f);
scale = 2*pi*i*eye(tstate);
for k = 1:1:n_fp
   w = f(k)*scale;
   x=(-s.a+w)\s.b;
   yy = s.c*x+s.d;
   y(k)={yy};
   sd = svd(yy);
   smn(k) = min(sd);
   smx(k) = max(sd);
   cn(k) = smx(k)/smn(k);
end
return