function st = plus(s1,s2,so1,so2,ro1,ro2)
%sums the outputs of two state space objects and creates a new state space object
%syntax st = plus(s1,s2,so1,so2,ro1,ro2)
%inputs two state space objects, s1 and s2
%       summed output indices so1 and so2 - must be the same length
%       retained output indices ro1 and ro2
%       
%output a new state space object representing the sum, with the input the inputs of s1 and s2
%       and with outputs the sum of the so1 outputs of s1 and so2 outputs of s2, 
%       and the ro1 outputs of s1 and the ro2 outputs of s2
%if only two inputs the outputs are summed and must be the same length

if (~isa(s1,'stsp')||~isa(s2,'stsp'))
    error('s1 and s2 must be state space objects')
elseif nargin==2
    % check number of outputs
    if s1.NumOutputs~=s2.NumOutputs
        error('the number of outputs in s1 and s2 must be equal')
    end
    no = s1.NumOutputs;
    st = [s1;s2];
    if ~isempty(st.c)
        cs = st.c(1:no,:)+st.c(no+1:2*no,:);
    else
        cs=[];
    end
    ds = st.d(1:no,:)+st.d(no+1:2*no,:);
    st = stsp(st.a,st.b,cs,ds);
elseif nargin~=6
    error('all indices must be specified')
elseif length(so1)~=length(so2)
    error('so1 must be the same length as so2')
else
    st = [s1;s2];
    if ~isempty(st.c)
        cs = st.c(so1,:)+st.c(s1.NumOutputs+so2,:);
        ds = st.d(so1,:)+st.d(s1.NumOutputs+so2,:);
        if (ro1+ro2)~=0
            if ro1~=0;
                cr1 = [s1.c(ro1,:) zeros(length(ro1),s2.NumStates)];
                dr1 = [s1.d(ro1,:) zeros(length(ro1),s2.NumInputs)];
            else 
                cr1=[];dr1=[];
            end
            if ro2~=0;
                cr2 = [zeros(length(ro2),s1.NumStates) s2.c(ro2,:)];
                dr2 = [zeros(length(ro2),s1.NumInputs) s2.d(ro2,:)];
            else 
                cr2=[];dr2=[];
            end
            cr = [cr1;cr2];
            dr = [dr1;dr2];
        else
            cr = [];dr=[];
        end
    else
        cs=[];cr=[];ds=[];dr=[];
    end
    st = stsp(st.a,st.b,[cs;cr],[ds;dr]);
end