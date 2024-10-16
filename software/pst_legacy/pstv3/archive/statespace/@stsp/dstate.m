function [y,xn,dx] = dstate(s,x,u,xmax,xmin,ymax,ymin)
% determines the rate of change of states for the state space object s
% syntax: [y,xn,dx] = dstate(s,x,u,xmax,xmin,ymax,ymin)
% impliments output limits and non-windup state limits
% inputs:
%        s - state space object
%        x - starting states (length equal to the number of states of s)
%        u - input vector (length equal to the number of inputs of s)
%        xmax - maximum value of x (length equal to the number of states of s)
%        xmin - minimum value of x (length equal to the number of states of s)
%        ymax - maximum value of y (length equal to the number of outputs of s)
%        ymin - minimum value of y (length equal to the number of outputs of s)
% outputs:
%        y - output vector
%        xn - limited state vector
%        dx - rate of change of state vector

% (c) copyright Cherry Tree Scientific Software 1998 - All rights reserved

nan_idx=find(isnan(x)==1);
if ~isempty(nan_idx)
    disp('the following states are NaN')
    disp(nan_idx)
    error('fatal dstate error')
end
switch nargin
case {1,2}
    error('you must specify at least s, x and u')
case  3
    a=s.a;b=s.b;c=s.c;d=s.d;
    dx = a*x + b*u;
    y = c*x + d*u;
    xn = x;
case {4,5,6,7}
    a=s.a;b=s.b;c=s.c;d=s.d;
    dx = a*x + b*u;
    % check length of xmax and xmin
    if length(xmax)~=s.NumStates||length(xmin)~=s.NumStates
        error('xmax and xmin must be vectors of length equal to the number of states of s')
    elseif length(ymax)~=s.NumOutputs||length(ymin)~=s.NumOutputs
        error('ymax and ymin must be vectors of length equal to the number of outputs of s')
    else
        % check state and apply non-windup limit
        minx_idx = find(x<=xmin);
        if ~isempty(minx_idx);
            x(minx_idx)=xmin(minx_idx);
            dxn_idx= find(dx(minx_idx)<0);
            if ~isempty(dxn_idx)
                dx(minx_idx(dxn_idx))=zeros(length(dxn_idx),1);
            end
        end
        maxx_idx = find(x>=xmax);
        if ~isempty(maxx_idx);
            x(maxx_idx)=xmax(maxx_idx);
            dxp_idx= find(dx(maxx_idx)>0);
            if ~isempty(dxp_idx)
                dx(maxx_idx(dxp_idx))=zeros(length(dxp_idx),1);
            end  
        end
        xn=x;
        y = c*xn + d*u;
        %check output limit
        min_idx = find(y<ymin);if ~isempty(min_idx);y(min_idx)=ymin(min_idx);end
        max_idx = find(y>ymax);if ~isempty(max_idx);y(max_idx)=ymax(max_idx);end
    end
end

