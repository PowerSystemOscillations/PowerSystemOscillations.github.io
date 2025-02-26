% The single machine infinite bus system for power system
% stabilizer design
% datalaag.m

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

disp('Lambton Data - modified for stabilizer design')

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
1 2 600  0.16 0.00234  1.81  0.30  0.217  7.80  0.022 ...
                       1.76  0.61  0.254  0.90  0.074 ...
                       3.53  0.00  0.00   2     0   0;
2 1 1e5  0.0  0.0      0.00  0.15  0.00   0.00  0.000 ...
                       0.00  0.00  0.00   0.00  0.000 ...
                      30.00 60.00  0.00   1     0   0];

% Exciter data format
% exciter:  1. exciter type - 0 for simple
%           2. machine number
%	    3.
%	    4. Ka
%	    5. Ta
%	    6. Tb
%	    7. Tc
%	    8. Vrmax
%	    9. Vrmin
exc_con = [
0  1 0.0  212 0.015 0.0 0.0 100 -100];

%pss data format
%1. pss type 1 for speed input
%2. machine number
%3. gain (K=Kstab*T)
%4. washout time constant
%5. lead time constant
%6. lag time constant
%7. lead time constant
%8. lag time constant
%9. max output limit
%pss_con = [1 1 0.0 1.41 0.154 0.033 0.1 0.1 0.2 -0.05];

% governor data
% 1. governor type = 1
% 2. machine number
% 3. speed set point, normally equal to 1 pu
% 4. gain (inverse of droop)
% 5. max power pu on gen base
% 6. servo time const. (s)
% 7. governor or HP time const (s)
% 8. transient gain time const (s)
% 9. T4 set to make T4/T5 = frac of HP
%10. T5 reheater time const
tg_con = [
% t n w0  1/R  Pmx  Ts  Tc  T3  T4  T5
  1 1 1   25.0 1.0  0.1 0.5 0.0 1.25 5.0];

ibus_con = [0 1]';
