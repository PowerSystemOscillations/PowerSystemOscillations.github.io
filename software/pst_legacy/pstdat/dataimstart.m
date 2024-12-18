% The three generator system system 
% with two induction motors starting at t = 0
% The induction motors both have leakage inductance saturation
% one motor has a deep bar rotor and the other a double cage rotor


% bus data format
% bus: 
% col1 number
% col2 voltage magnitude(pu)
% col3 voltage angle(degree)
% col4 p_gen(pu)
% col5 q_gen(pu)
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
%  the voltage on bus 2 is adjusted for zero Q at machine 1
bus = [ 1 1.0    0.0   .025   0.0  0.0  0.0  0.0  0.0  2  999  -999;
        2 1.0    0.0   .025   0.0  0.0  0.0  0.0  0.0  2  999  -999;
        3 1.0    0     0      0    0    0    0.0  0.0  3  0     0;
        4 1.0    0     0      0    0.   0.   0    0    3  0     0;
        5 1.0    0     0      0    0.   0    0    0    3  0     0;
        6 1.0    0     0      0    0.02 0    0    0    3  0     0;
        7 1.0    0     0.45   0    0.5  0.1  0    0    1  999  -999;
        
    ];

% line data format
% line: from bus, to bus, resistance(pu), reactance(pu),
%       line charging(pu), tap ratio, phase shifter angle

line = [1  3  0.0     0.8     0.       1. 0.;
        2  3  0.0     0.8     0.       1. 0.;
        3  4  0.0     0.8     0.       1. 0.;
        3  5  0.0     0.8     0.       1. 0.;
        3  6  0.0     0.8     0.       1. 0.;
        3  7  0.07591 0.08778 0.03046  1  0;
    ];

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
% note: machine 1 uses mac_sub model, machine 2 uses mac_em
%       model
mac_con = [
1 1 3.125   0.13 0     1.6    0.42  0.271  4.34 0.027  ...
                       0.963  0.30  0.271  1.00 0.030 ...
                       3      6.0   0   1  0     0;
2 2 3.125   0.13 0     1.6    0.42  0.271  4.34 0.027  ...
                       0.963  0.30  0.271  1.00 0.030 ...
                       3      6.0   0   1  0     0;
3 7 105     0.12 0.002  1.48   0.18  0.013  8.0    0.028 ...
                       1.48   0.33  0.013  1.61   0.198 ...
                       5.95   10.0  0   2    0    0;
               ];
mac_con = [
1 1 3.125   0.13 0     1.6    0.42  0.271  4.34 0.027  ...
                       0.963  0.30  0.271  1.00 0.030 ...
                       3      6.0   0   1  0.0654  0.5743;
2 2 3.125   0.13 0     1.6    0.42  0.271  4.34 0.027  ...
                       0.963  0.30  0.271  1.00 0.030 ...
                       3      6.0   0   1  0.0654  0.5743;
3 7 105     0.12 0.002  1.48   0.18  0.013  8.0    0.028 ...
                       1.48   0.33  0.013  1.61   0.198 ...
                       5.95   10.0  0   2   0.0654  0.5743;
               ];
% Exciter data format
% exciter:  1. exciter type - 3 for ST3
%           2. machine number
%           3. input filter time constant T_R 
%           4. voltage regulator gain K_A
%           5. voltage regulator time constant T_A
%           6. voltage regulator time constant T_B
%           7. voltage regulator time constant T_C
%           8. maximum voltage regulator output V_Rmax
%           9. minimum voltage regulator output V_Rmin
%          10. maximum internal signal V_Imax
%          11. minimum internal signal V_Imin
%          12. first stage regulator gain K_J
%          13. potential circuit gain coefficient K_p
%          14. potential circuit phase angle theta_p
%          15. current circuit gain coefficient K_I
%          16. potential source reactance X_L
%          17. rectifier loading factor K_C
%          18. maximum field voltage E_fdmax 
%          19. inner loop feedback constant K_G
%          20. maximum inner loop voltage feedback V_Gmax

exc_con = [...
0 1 0 200.0  0.05     0     0    5.0  -5.0...
    0    0      0     0     0    0    0      0      0    0   0;
0 2 0 200.0  0.05     0     0    5.0  -5.0...
    0    0      0     0     0    0    0      0      0    0   0;
0 3 0 20.0  0.05     0     0    5.0  -5.0...
    0    0      0     0     0    0    0      0      0    0   0;
];



% governor data
% 1. governor type = 1
% 2. machine number
% 3. speed set point , normally equal to 1
% 4. gain ( inverse of droop)
% 5. max power pu on gen base
% 6. servo time const. s
% 7. governor or HP time const s
% 8. transient gain time const s
% 9. T4 set to make T4/T5 = frac of HP
%10. T5 reheater time const
tg_con=[...
        1 1  1.0  25.0 1.0  0.1  0.4  0.1  -5.0  2.5;
        1 2  1.0  25.0 1.0  0.1  0.4  0.1  -5.0  2.5;
        1 3  1.0  25.0 1.0  0.1  0.4  0.0  1.25  5.0;
];

% induction motor data
% 1. Motor Number
% 2. Bus Number
% 3. Motor MVA Base
% 4. rs pu
% 5. xs pu - stator leakage reactance
% 6. Xm pu - magnetizing reactance
% 7. rr pu 
% 8. xr pu - rotor leakage reactance
% 9. H  s  - motor plus load inertia constant
% 10. rr1 pu - second cage resistance
% 11. xr1 pu - intercage reactance
% 12. dbf    - deepbar factor
% 13. isat pu - saturation current
% 15. fraction of bus power drawn by motor ( if zero motor statrts at t=0)
ind_con = [ ...
  1  4  2.86 .02563  .09118 4.6557  .009891  .09118   1.0 0       0    7.3325 3 0 0;% deep bar and leakage inductance saturation
  2  5  2.86 .03274 .08516 3.7788 .06164 .06005  1.0 0.01354 0.07517 0     3 0 0;% double cage and leakage indctance saturation
];
% Motor Load Data 
% format for motor load data - mld_con
% 1 motor number
% 2 bus number
% 3 stiction load pu on motor base (f1)
% 4 stiction load coefficient (i1)
% 5 external load  pu on motor base(f2)
% 6 external load coefficient (i2)
% 
% load has the form
% tload = f1*slip^i1 + f2*(1-slip)^i2
mld_con = [ ...
1  5  .1  1  .8  2
2  6  .1  1  .8  2
];

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
%                            - 6 no fault
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
0    0    0    0    0    0    0.001;%sets intitial time step
0.1  4    3    0    0    6    0.001; %no fault
0.15 0    0    0    0    0    0.001; 
0.20 0    0    0    0    0    0.001; 
0.50 0    0    0    0    0    0.001; 
1.0  0    0    0    0    0    0.005;
5    0    0    0    0    0    0]; % end simulation




