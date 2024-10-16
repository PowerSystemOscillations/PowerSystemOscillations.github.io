function p = cdps(dir)
if nargin==0
    p = 'D:\PSTV2\';
else
    p = ['D:\PSTV2\' dir];
end
cd(p)