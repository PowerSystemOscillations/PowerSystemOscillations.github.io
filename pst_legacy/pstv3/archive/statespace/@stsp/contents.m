% State Space Object and Functions
% stsp                  - constructor for state space object
% eval                  - evaluates a state space object 
% vertcat               - s = [s1;s2] - stacks two state space objects
% eq                    - s1==s2 ; 1 if true, 0 if false
% transpose             - s1=s.'  s1.a=s.a.';s1.b=s.c.',s1.c=s.b.',s1.d=s.d.'
% times                 - st=s1.*s2 may be augmented 
% minus                 - sm = s1-s2
% plus                  - sp = s1+s2 may be augmented
% uminus                - s1 = -s
% parallel              - combines to state space objects with same number of inputs and outputs 
%                         into one with the input applied equally to both subsystems and the output being the sum
%                         of the outputs from the two subsystems
% fb_aug                - connects two state space objects in feed back loop
%                         feedback inputs and outputs may be specified
%                         retained inputs and outputs may be specified
% fr_stsp               - frequency response of single input single output state space object
% fr_mstsp              - frequency response of multivariable state space object
% stres                 - step response
% eig                   - eigenvalues of a state space object, overrides eig
% cpc_stsp              - robust control design based on co-prime uncertainty (uses mu- analysis and synthesis toolbox)
% dstate                - determines the rate of change of states for the state space object s
%                         impliments output limits and non-windup state limits
% get                   - creates a structure with the same fields as the state space object
% init_stsp             - finds the initial input vector and the initial states to satisfy an initial output y
% nlsr                  - nonlinear response to step, ramp or impulse
%                       - states non-windup limited, output limited
% norm_copr             - forms the normalized co-prime factors of a state space object (uses mu analysis and synthesis toolbox)
% reduss                - ballanced residual reduction of an unstable system (uses mu analysis and synthesis toolbox)
% residue               - calculates the residues of a state space object
% rtlocus               - calculates the rootlocus of two state space objects connected in feedback
% ss2tf                 - converts state space object to transfer function object
% stabred               - balanced residual reduction for stable state space object
% stsp2sys              - converts a state space object to a mu-tools sys matrix
% sys2stsp              - converts a mu-tools sys matrix to a state space object
% tr_stsp               - calculates the response of a state space object to a user defined time function

