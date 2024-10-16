% M file generates the torsional model data for use in tor_mod.m
% Thie example corresponds to the 555 MVA Lambton generating station
%
% M1 = 0.248; M2 = 0.464; M3 = 2.310; M4 = 2.384; M5 = 1.710;  % inertia constants
%
% generator is mass number 5
% K12 = 21.8; K23 = 48.4; K34 = 75.6; K45 = 62.3;    % torsional stiffness
% D1 = 0.0; D2 = 0.0; D3 = 0.0; D4 = 0.0; D5 = 0.0;  % damping coefficients
% r1 = 0.25; r2 = 0.25; r3 = 0.25; r4 = 0.25;        % mechanical power input fractions

sys_freq = 60;  % in Hz
n_mass = 5;
n_Pe = 5;       % generator is mass/section number 5

M = [0.248, 0.464, 2.310, 2.384, 1.710];
D = [0.0, 0.0, 0.0, 0.0, 0.0];
K = [21.8, 48.4, 75.6, 62.3];
R = [0.25, 0.25, 0.25, 0.25, 0.0];

tor_mod_con.sys_freq = sys_freq;
tor_mod_con.n_mass = n_mass;
tor_mod_con.n_Pe = n_Pe;

tor_mod_con.M = M;
tor_mod_con.D = D;
tor_mod_con.K = [K 0];
tor_mod_con.R = R;

% eof
