% frequency response
%syntax: [f,ymag,yphase]=fr_stsp(s,ftype,fstart,fstep,fend)
%calculates frequency response from state space object
% s is a state space object - which must have a non-empty state matrix
% ftype = 'lin' gives a linear set of frequencies
% ftype = 'log' gives a logarithmic range of frequencies
%         in this case fstep is treated as a multiplier - minimum value 1.01
% if fstart, fstep and fend are not entered, ftype must be a vector of frequencies in Hz
% fstart is the start frequency in Hz
% fstep is the frequency step in Hz
% fend is the end frequency in Hz
%
% f is the frequency vector used for plotting
% ymag is the magnitude vector
% yphase is the phase vector in degrees
% for logarithmic plots use loglog(f,ym) and semilogx(f,ya)
% limited to single input-single output systems

% Author: Graham Rogers
% Date:   September 1994
% Modified September 1996
% Modified January 1998
function [f,ymag,yphase] = fr_stsp(s,ftype,fstart,fstep,fend)
if ~isa(s,'stsp')
   error('s must be a state space object')
end
if isempty(s.a);error('the state space object is not dynamic');end
if s.NumInputs~=1
   error('only single input systems are allowed')
%elseif s.NumOutputs~=1;
%   error('only single output systems are allowed')
end   
tstate = s.NumStates;
if nargin==2
   f=ftype;
elseif strcmp(ftype,'lin');
   f = fstart:fstep:fend;
elseif strcmp(ftype,'log');
   if fstep<1.01;fstep=1.01;end
   fslog = log(fstart);
   felog = log(fend);
   fstlog = log(fstep);
   flog = fslog:fstlog:felog;
   f = exp(flog);
end
n_fp = length(f);
w1 = 2*pi*i*diag(ones(tstate,1));
y=zeros(s.NumOutputs,n_fp);
for k = 1:1:n_fp
 w = f(k)*w1;
 x=(-s.a+w)\s.b;
 y(:,k)=s.c*x+s.d;
end
ymag = abs(y);
numout = s.NumOutputs;
yphase = zeros(size(y));
for j = 1:numout
    yphase(j,:) = 180*unwrap(angle(y(j,:)))/pi;
end
return