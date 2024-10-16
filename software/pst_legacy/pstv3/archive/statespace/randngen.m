function x = randngen(n,m,tag)
randn('state',sum(100*clock));
switch nargin
case 0
    x = randn;
case 1
    x = randn(n,1);
case 2
    x = randn(n,m);
case 3
    switch tag
    case 'rand'
        x = rand(n,m);
    case 'randn'
        x = randn(n,m);
    end
end