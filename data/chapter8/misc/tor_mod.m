function [tor] = tor_mod(tor_mod_con)
% Syntax: [tor] = tor_mod(tor_mod_con)
% May 19, 2022
% Purpose: Generate the linearized ABCD matrices for a turbine-generator
%            torsional model given the torsional model data in tor_mod_con
%            Please see tor_mod_data.m for the construction of tor_mod_con.
%            The output is a state-space object containing the linear
%            model.
%
% Input: tor_mod_con - this is a 5xn matrix where n is the number of masses
%            It also has the data for system frequency, number of masses,
%            and the index for the generator section.
%
% Output: tor - this is a struct containing the state matrix.
%
% Files:
%
% See Also: tor_mod_data.m, smib_tor_mod.m
%
% (c) Copyright 2022 Joe H. Chow - All Rights Reserved
% History (in reverse chronological order)

% tor_mod_con is a struct with the fields:
%    sys_freq -- system frequency in Hz
%    n_mass -- number of masses/sections
%    n_Pe -- position of the generator
%    M -- mass of each section, starting from high-pressure (HP) end
%    D -- damping coefficent of each section
%    K -- stiffness coefficient of each section
%    R -- input power fractions

Omega = 2*pi*tor_mod_con.sys_freq;
n_mass = tor_mod_con.n_mass;
Pe_idx = tor_mod_con.n_Pe;
M = diag([ones(1,n_mass) tor_mod_con.M]);  % M = diag([1 1 1 1 1 M1 M2 M3 M4 M5]);

% A has the form
% [ 0        0             0             0            0       wb     0      0      0      0     ;
%   0        0             0             0            0       0      wb     0      0      0     ;
%   0        0             0             0            0       0      0      wb     0      0     ;
%   0        0             0             0            0       0      0      0      wb     0     ;
%   0        0             0             0            0       0      0      0      0      wb    ;
%  -K12/M1   K12/M1        0             0            0      -D1/M1  0      0      0      0     ;
%   K12/M2 -(K12+K23)/M2   K23/M2        0            0       0     -D2/M2  0      0      0     ;
%   0        K23/M3      -(K23+K34)/M3   K34/M3       0       0      0     -D3/M3  0      0     ;
%   0        0             K34/M4      -(K34+K45)/M4  K45/M4  0      0      0     -D4/M4  0     ;
%   0        0             0             K45/M5      -K45/M5  0      0      0      0     -D5/M5];

A11 = zeros(n_mass,n_mass);
A12 = Omega*eye(n_mass);
A21 = [-tor_mod_con.K(1) tor_mod_con.K(1) zeros(1,n_mass-2)];

for ii = 2:n_mass-1
   A21 = [A21; zeros(1,ii-2), tor_mod_con.K(ii-1), ...
          -(tor_mod_con.K(ii-1) + tor_mod_con.K(ii)), tor_mod_con.K(ii), zeros(1,n_mass-1-ii)];
end

A21 = [A21; zeros(1,n_mass-2) tor_mod_con.K(n_mass-1) -(tor_mod_con.K(n_mass-1))];
A22 = -diag(tor_mod_con.D);

A = inv(M)*[A11 A12; A21 A22];

tor.a_mat = A;

% eof
