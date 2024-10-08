function [lz,uz,vz] = zeros(s);
% calculates the transmission zeros of a full state space system
if issparse(s.a)
    s=full(s);
end
A = [s.a s.b;s.c s.d];
NumInputs = s.NumInputs;
NumOutputs = s.NumOutputs;
NumStates = s.NumStates;
B = [eye(NumStates) zeros(NumStates,NumInputs);zeros(NumOutputs,NumStates) zeros(NumOutputs,NumInputs)];
[uz,lz] = eig(A,B);
[lz,lz_idx] = sort(diag(lz));
uz = uz(:,lz_idx);
vz = inv(uz);