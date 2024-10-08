function [X,X1,Xp,Xpp,rs,Xs,Tpp,Tp] = inspect2ptiim(rs,xs,Xm,rr1,xr1,rr2,xr2,fo);
if nargin < 7
    uiwait(msgbox('you must supply all equivalent circuit parameters','conv error','modal'))
    return
end
if nargin==8
    if fo==0
        wo = 2*pi*60;
    else
        wo = 2*pi*fo;
    end
else
    wo = 2*pi*60;
end
X = xs+Xm;
X1 = xs;
Xp = xs+1/(1/Xm + 1/(xr1+xr2));
Xpp = xs+1/(1/Xm + 1/xr1);
rs = rs;
Xs = Xpp;
Tpp = 1/(1/(Xm+xs)+1/xr2)/wo/rr1;
Tp = (Xm+xr1+xr2)/wo/rr2;
