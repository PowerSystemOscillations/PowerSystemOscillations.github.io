function s_v = get(s)
% syntax s_v = getstsp(s)
% overloads get for state space objects
   s_v.a = s.a;
   s_v.b = s.b;
   s_v.c = s.c;
   s_v.d = s.d;
   s_v.NumStates = s.NumStates;
   s_v.NumInputs = s.NumInputs;
   s_v.NumOutputs = s.NumOutputs;
