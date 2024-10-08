% The single machine infinite bus system for power system
% stabilizer design
% datasmse.m

% bus data format
% bus:
% col1 number
% col2 voltage magnitude(pu)
% col3 voltage angle(degree)
% col4 p_gen(pu)
% col5 q_gen(pu),
% col6 p_load(pu)
% col7 q_load(pu)
% col8 G shunt(pu)
% col9 B shunt(pu)
% col10 bus_type
%       bus_type - 1, swing bus
%                - 2, generator bus (PV bus)
%                - 3, load bus (PQ bus)
% col11 q_gen_max(pu)
% col12 q_gen_min(pu)
bus = [1  1.0   0.0   1.33   0.73  0.0  0.00  0.0  0.0  1  0    0;
       2  1.0   0.0   5.40   1.08  0.0  0.00  0.0  0.0  2  9   -9;
       3  1.0     0      0      0    0     0  0.0  0.0  3  0    0;
       4  1.0     0      0      0  6.6  0.15  0.0  0.0  3  0    0];

% line data format
% line: from bus, to bus, resistance(pu), reactance(pu),
%       line charging(pu), tap ratio, phase shifter angle
line = [1  4  0.0000  0.0576  0.0  1.0  0.0;
        2  3  0.0000  0.0144  0.0  1.0  0.0;
        3  4  0.0085  0.0720  0.0  1.0  0.0;
        3  4  0.0085  0.0720  0.0  1.0  0.0];
    
% Machine data format
% machine:  1. machine number
%           2. bus number
%           3. base mva
%           4. leakage reactance x_l(pu)
%           5. resistance r_a(pu)
%           6. d-axis sychronous reactance x_d(pu)
%           7. d-axis transient reactance x'_d(pu)
%           8. d-axis subtransient reactance x"_d(pu)
%           9. d-axis open-circuit time constant T'_do(sec)
%          10. d-axis open-circuit subtransient time
%                constant T"_do(sec)
%          11. q-axis sychronous reactance x_q(pu)
%          12. q-axis transient reactance x'_q(pu)
%          13. q-axis subtransient reactance x"_q(pu)
%          14. q-axis open-circuit time constant T'_qo(sec)
%          15. q-axis open circuit subtransient time
%                constant T"_qo(sec)
%          16. inertia constant H(sec)
%          17. damping coefficient d_o(pu)
%          18. dampling coefficient d_1(pu)
%          19. bus number
%          20. S(1.0) - saturation factor
%          21. S(1.2) - saturation factor
% note: machine 1  use mac_sub model
mac_con = [
1 2 600  0.20 0.0      0.00  0.25  0.00   0.00  0.00 ...
                       0.00  0.00  0.00   0.00  0.00 ...
                      12.00  0.00  0.00   2     0   0;                       
2 1 1e5  0.0  0.0      0.00  0.15  0.00   0.00  0.000 ...
                       0.00  0.00  0.00   0.00  0.000 ...
                      30.00 60.00  0.00   1     0   0];

ibus_con = [0 1]';
