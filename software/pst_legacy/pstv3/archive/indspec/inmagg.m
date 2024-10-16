function speca = inmagg(spec) 
% syntax: speca = inmagg(spec);
% purpose: determines spcifications of an aggregate induction motor given
% specifications of a group of induction motors on a common bus
% input: a specification matrix for the motors to be aggregated
% output: a specification vector for the aggrgate motor
%Specifcation matrix definition
%spec(:,1) = Rated Voltage (KV)
%spec(:,2) = Rated Current (KA)
%spec(:,3) = Rated Frequency (Hz)
%spec(:,4) = Rated Power Output(MW)
%spec(:,5) = Rated Power Factor
%spec(:,6) = Rated Fractional Efficiency
%spec(:,7) = ratio of starting current to full load currrent
%spec(:,8) = Ratio of Starting Torque to Full Load Torque
%spec(:,9) = Ratio of Maximum Torque to Full Load Torque
%spec(:,10) = Full Load Slip
%spec(:,11) = Moment of Inertia (Kilogram metre squared)
%spec(:,12) = Number of poles
speca = zeros(1,12);
speca(12) = max(spec(:,12));
sphi = sqrt(1-spec(:,5).*spec(:,5));
Id = spec(:,2).*spec(:,5);Iq = spec(:,2).*sphi;
sId = sum(Id);sIq = sum(Iq);
speca(1)=spec(1,1);speca(3) = spec(1,3);
speca(2) = sqrt(sId.*sId+sIq.*sIq);
speca(4) = sum(spec(:,4));
speca(6) = sum(spec(:,6).*Id)./sum(Id);
Tfl = (0.5/pi)*spec(:,12)./spec(:,4)./(1-spec(:,10));
To = speca(12)*sum(Tfl./spec(:,12));
Pin = sqrt(3)*spec(:,1).*spec(:,2).*spec(:,5);
Qin = sqrt(3)*spec(:,1).*spec(:,2).*sphi;
Pagg = sum(Pin);Qagg = sum(Qin);
tanphiagg = Qagg/Pagg;
cosphiagg = sqrt(1/(1+tanphiagg*tanphiagg));
speca(5) = cosphiagg;
speca(10) = sum(spec(:,10).*Tfl)/sum(To);
Ist = spec(:,7).*spec(:,2);
speca(7) = sum(Ist)/speca(2);
speca(8) = (speca(12)/speca(2))*sum(spec(:,8).*spec(:,2)./spec(:,12));
speca(9) = (speca(12)/speca(2))*sum(spec(:,9).*spec(:,2)./spec(:,12));
k = (1-spec(:,10))./spec(:,12);
speca(11)= sum(spec(:,11).*k.*k);
k1 = (1-speca(10))/speca(12);
speca(11) = speca(11)/k1/k1;
