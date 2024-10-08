function s=stsp(a,b,c,d)
% constructor for a state space object
% syntax s = stsp(a,b,c,d)
% output state space object or a cell of state space objects
% inputs
% either:
%       a - nxn state matrix
%       b - nxm input matrix
%       c - oxn output matrix
%       d - oxm feed forward matrix
% or:
%       a is a state space object or a cell of state space objects
% or:
%       a is a cell of state space matrices
%       b is a cell of input matrices
%       c is a cell of output matrices
%       d is a cell of feed forward matrices
%       the corresponding cells must be consistent

% author Graham Rogers
% modified for cells
% October 1999
% date 25 January 1998
% copyright Cherry Tree Scientific Software 1998
if nargin==0
    s.NumStates = 0;
    s.a = [];
    s.b=[];
    s.c = [];
    s.d = [];
    s.NumInputs = 0;
    s.NumOutputs = 0;
    s = class(s,'stsp');
    return
elseif isempty(a)
    s.NumStates = 0;
    ni = 0;
    no = 0;
    s.a=[];
    s.b=[];
    s.c=[];
    if nargin == 4 && ~isempty(d)
        s.d=d;
        [row,col]=size(d);
        ni = col;
        no = row;
    else
        s.d=[];
    end
    s.NumInputs = ni;
    s.NumOutputs = no;
    s = class(s,'stsp');
    return
elseif isa(a,'stsp')
    s=a;
elseif isa(a,'cell')
    nc = length(a);
    noss = ones(1,nc);
    for j = 1:nc
        if isa(a{j},'stsp');noss(j)=0;end
    end
    if sum(noss)~=0&&sum(noss)~=nc
        error(' with cell inputs, all a elements must be state space objects, or square state matrices')
    elseif sum(noss)==0
        % all a elements are state space objects
        for j = 1:nc
            s(j)={a{j}};
        end
        return
    end
end
if nargin~=4
    error('all state space matrices must be specified')
else
    if isa(a,'cell');
        nss = length(a);
        for j = 1:nss
            if ~isa(b,'cell');error('if a is a cell b must be a cell');end
            if ~isa(c,'cell');error('if a is a cell c must be a cell');end
            if ~isa(d,'cell');error('if a is a cell d must be a cell');end
            %construct a cell of state space objects
            [nrow,ncol]=size(a{j});
            if nrow~=ncol
                error('the state matrix must be square')
            end
            s1.NumStates=nrow;
            s1.a = a{j};
            s1.b = b{j};
            s1.c = c{j};
            s1.d = d{j};
            if ~isempty(b{j})
                [nrowb,ncolb]=size(b{j});
                if nrowb~=s1.NumStates
                    error(['the ' int2str(j) ' b matrix must have the same number of rows as the a matrix'])
                else
                    s1.NumInputs = ncolb;
                end
            elseif ~isempty(d{j})
                [nrowd,ncold]=size(d{j});
                s1.NumInputs = ncold;
            else
                warning('empty d matrix - state space set to empty')
                s1.NumStates=0;s1.a = [];s1.b=[];s.c=[];s1.d=[];
                s1.NumInputs = 0;s1.NumOutputs=0;
                s(j) = {class(s1,'stsp')};
                return
            end 
            if ~isempty(c{j})
                [nrowc,ncolc]=size(c{j});
                if ncolc~=s1.NumStates
                    error(['the ' int2str(j) ' c matrix must have the same number of columns as the a matrix'])
                else
                    s1.NumOutputs = nrowc;
                end
            else
                [nrowd,ncold]=size(d{j});
                s1.NumOutputs = nrowd;
            end
            [nrowd,ncod]=size(d{j});
            if nrowd~=s1.NumOutputs;
                error(['the ' int2str(j) ' d matrix must have the same number of rows as the c matrix'])
            elseif ncold~=s1.NumInputs
                error(['the ' int2str(j) 'd matrix must have the same number of columns as the b matrix'])
            end
            s(j) = {class(s1,'stsp')};
        end
    else
        [nrow,ncol]=size(a);
        if nrow~=ncol
            error('the state matrix must be square')
        end
        s1.NumStates=nrow;
        [nrowb,ncolb]=size(b);
        if nrowb~=s1.NumStates
            error('the b matrix must have the same number of rows as the a matrix')
        end
        [nrowc,ncolc]=size(c);
        if ncolc~=s1.NumStates
            error('the c matrix must have the same number of columns as the a matrix')
        end
        [nrowd,ncold]=size(d);
        if nrowd~=nrowc;
            if nrowc == 0
                nrowc = nrowd;
            else   
                error('the d matrix must have the same number of rows as the c matrix')
            end
        elseif ncold~=ncolb
            if ncolb==0
                ncolb=ncold;
            else
                error('the d matrix must have the same number of columns as the b matrix')
            end
        end
        if issparse(a)
            s1.a = a;
            s1.b = sparse(b);
            s1.c = sparse(c);
            s1.d = sparse(d);
        elseif isempty(a)&&issparse(d)
            s1.a = sparse(a);
            s1.b = sparse(b);
            s1.c = sparse(c);
            s1.d = d;
        else
            s1.a = a;
            s1.b = full(b);
            s1.c = full(c);
            s1.d = full(d);
        end
        s1.NumInputs = ncolb;
        s1.NumOutputs = nrowc;
        s = class(s1,'stsp');
    end
end
