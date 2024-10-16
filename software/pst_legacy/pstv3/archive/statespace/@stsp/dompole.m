function [l,xs,vs,ps,rs] = dompole(s,ls);
% computes the dominant poles
% s state space object, single input, single output
% ls initial pole estimate
%l dominant poles
% check inputs and outputs
if s.NumInputs~=1||s.NumOutputs~=1
    uiwait(msgbox('for dominant poles s must be single input single output','dompole error','modal'))
    l=ls;
    return
end
if size(ls,1)==1;ls=ls.';end
l=[];
le = ones(length(ls),1);
ls0=ls;
n_it = 0;
xs = [];vs=[];
while ((max(le)>1e-5)&&~isempty(ls))&&n_it<50;
    n_it=n_it+1;
    m = length(ls);
    x=zeros(s.NumStates+1,1);
    x1 = zeros(s.NumStates,m);z1=x1;
    y =  zeros(s.NumStates+1,1);
    y(s.NumStates+1)=1;
    lsr = find(abs(imag(ls))<1000*eps);
    ls(lsr)=real(ls(lsr));
    for k = 1:m
        A = [ls(k)*eye(s.NumStates)-s.a -s.b;...
              -s.c  -s.d];
        [L,U]=lu(A);
        x = U\(L\y);
        z = L.'\(U.'\y);
        x1(:,k)=x(1:s.NumStates);z1(:,k)=z(1:s.NumStates,1);
        if(~isempty(find(k==lsr)))
            x1(:,k)=real(x1(:,k));
            z1(:,k)=real(z1(:,k));
        end          
    end
    G = z1.'*x1;
    H = z1.'*s.a*x1;
    B = G\H;
    [u,ls2]=eig(B);
    ls = diag(ls2);
    x1 = x1*u;z1 = z1*inv(u);  
    le = abs(ls-ls0);
    ls0=ls;
    con = find(le<1e-5);
    if ~isempty(con)
        l=[l;ls(con)];
        xs =[xs x1(:,con)];
        vs =[vs z1(:,con)];
        m = m-length(con);
        ls(con)=[];ls0(con)=[];
        % normalize xs and vs
        xn = diag(1./sqrt(diag(vs.'*xs)));
        xs = xs*xn;vs=vs*xn;
    end 
end  
lsr = find(abs(imag(l))<1e9*eps);
l(lsr)=real(l(lsr));
xs(:,lsr)=real(xs(:,lsr));
vs(:,lsr)=real(vs(:,lsr));
mxxs = max(xs,[],1);
xs = xs*diag(1./mxxs);
vs = vs*diag(mxxs);
ps = vs.*xs;
vs = vs.';
for k=1:length(l)
      rs(k)=(s.c*xs(:,k))*(vs(k,:)*s.b);
end