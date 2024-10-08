%spec(:,1) = Rated Voltage (KV)
%spec(:,2) = Rated Current (KA)
%spec(:,3) = Rated Frequency (Hz)
%spec(:,4) = Rated Power (MW)
%spec(:,5) = Rated Power Factor
%spec(:,6) = Rated Fractional Efficiency
%spec(:,7) = ratio of starting current to full load current
%spec(:,8) = Ratio of Starting Torque to Full Load Torque
%spec(:,9) = Ratio of Maximum Torque to Full Load Torque
%spec(:,10) = Full Load Slip
%spec(:,11) = Moment of Inertia (Kilogram metre squared)
%spec(:,12) = Number of poles
spec = [...
    .38 .09  50 .00746*6.3  .9  .86 6.2    1.9 2.6 0.0233 .014 2;
    .38 .09  50 .00746*6.3  .9  .86 6.2    1.9 2.6 0.0233 .014 2;
    .38 .105 50 .00746*7.5  .91 .88 6.5    2.0 2.7 0.0217 .019 2;
    .38 .105 50 .00746*7.5  .91 .88 6.5    2.0 2.7 0.0217 .019 2;
    .38 .123 50 .00746*8.8  .91 .88 7.1    2.3 2.7 0.0200 .019 2;
    .38 .123 50 .00746*8.8  .91 .88 7.1    2.3 2.7 0.0200 .019 2;
    .38 .154 50 .00746*10   .83 .89 7.3    2.6 3.0 0.0167 .033 2;
    .38 .191 50 .00746*12.9 .86 .88 5.8    2.0 2.3 0.0233 .033 2;
    .38 .191 50 .00746*12.9 .86 .88 5.8    2.0 2.3 0.0233 .033 2;
    .38 .290 50 .00746*20.0 .88 .91 6.1    1.6 2.7 0.0200 .075 2;
    ];
    %1   2   3   4           5   6   7     8   9       10 11   12