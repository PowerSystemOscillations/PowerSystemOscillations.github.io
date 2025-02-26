% The multiple machine infinite bus system for power system
% stabilizer design
% datalam.m

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
%
bus = [1  1.0   0.0   1.33   0.73  0.0  0.00  0.0  0.0  1  0    0;
       2  1.0   0.0   1.35   0.27  0.0  0.00  0.0  0.0  2  9   -9;
       3  1.0   0.0   1.35   0.27  0.0  0.00  0.0  0.0  2  9   -9;
       4  1.0   0.0   1.35   0.27  0.0  0.00  0.0  0.0  2  9   -9;
       5  1.0   0.0   1.35   0.27  0.0  0.00  0.0  0.0  2  9   -9;
       6  1.0     0      0      0    0     0  0.0  0.0  3  0    0;
       7  1.0     0      0      0  6.6  0.15  0.0  0.0  3  0    0];

% line data format
% line: from bus, to bus, resistance(pu), reactance(pu),
%       line charging(pu), tap ratio, phase shifter angle
line = [1  7  0.0000  0.0576  0.0  1.0  0.0;
        2  6  0.0000  0.0576  0.0  1.0  0.0;
	3  6  0.0000  0.0576  0.0  1.0  0.0;
        4  6  0.0000  0.0576  0.0  1.0  0.0;
	5  6  0.0000  0.0576  0.0  1.0  0.0;
        6  7  0.0085  0.0720  0.0  1.0  0.0;
        6  7  0.0085  0.0720  0.0  1.0  0.0];

disp('Lambton Dynamic Data')

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
% note: machines in plant use mac_sub model, inf bus em
mac_con = [
1 2 150  0.16 0.00234  1.81  0.30  0.217  7.80  0.022 ...
                       1.76  0.61  0.254  0.90  0.074 ...
                       3.53  0.00  0.00   2     0   0;
2 3 150  0.16 0.00234  1.81  0.30  0.217  7.80  0.022 ...
                       1.76  0.61  0.254  0.90  0.074 ...
                       3.53  0.00  0.00   3     0   0;
3 4 150  0.16 0.00234  1.81  0.30  0.217  7.80  0.022 ...
                       1.76  0.61  0.254  0.90  0.074 ...
                       3.53  0.00  0.00   4     0   0;
4 5 150  0.16 0.00234  1.81  0.30  0.217  7.80  0.022 ...
                       1.76  0.61  0.254  0.90  0.074 ...
                       3.53  0.00  0.00   5     0   0;
5 1 1e5  0.0  0.0      0.00  0.15  0.00   0.00  0.000 ...
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
0  1 0.02 212 0.05  0.0 0.0 5.0 -5.0;
0  2 0.02 212 0.05  0.0 0.0 5.0 -5.0;
0  3 0.02 212 0.05  0.0 0.0 5.0 -5.0;
0  4 0.02 212 0.05  0.0 0.0 5.0 -5.0];

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
%10. min output limit
%pss_con= [1 1 14. 1.41 .0540 .033 .02 .02 .2 -0.05;
%          1 2 14. 1.41 .0540 .033 .02 .02 .2 -0.05;
%          1 3 14. 1.41 .0540 .033 .02 .02 .2 -0.05;
%          1 4 14. 1.41 .0540 .033 .02 .02 .2 -0.05];

%Switching file defines the simulation control
% row 1 col1  simulation start time (s) (cols 2 to 6 zeros)
%       col7  initial time step (s)
% row 2 col1  fault application time (s)
%       col2  bus number at which fault is applied
%       col3  bus number defining far end of faulted line
%       col4  zero sequence impedance in pu on system base
%       col5  negative sequence impedance in pu on system base
%       col6  type of fault  - 0 three phase
%                            - 1 line to ground
%                            - 2 line-to-line to ground
%                            - 3 line-to-line
%                            - 4 loss of line with no fault
%                            - 5 loss of load at bus
%       col7  time step for fault period (s)
% row 3 col1  near end fault clearing time (s) (cols 2 to 6 zeros)
%       col7  time step for second part of fault (s)
% row 4 col1  far end fault clearing time (s) (cols 2 to 6 zeros)
%       col7  time step for fault cleared simulation (s)
% row 5 col1  time to change step length (s)
%       col7  time step (s)
%
%
%
% row n col1 finishing time (s)  (n indicates that intermediate rows may be inserted)

sw_con = [...
0    0    0    0    0    0    0.01;%sets intitial time step
0.1  6    7    0    0    0    0.005; %apply three phase fault at bus 3, on line 3-101
0.15 0    0    0    0    0    0.005556; %clear fault at bus 3
0.20 0    0    0    0    0    0.005556; %clear remote end
0.50 0    0    0    0    0    0.01; % increase time step
1.0  0    0    0    0    0    0.02; % increase time step
2.0  0    0    0    0    0    0]; % end simulation

ibus_con = [0 0 0 0 1]';
