% G. Rogers, R. Elliott, D. Trudnowski, F. Wilches-Bernal, D. Osipov,
% J. Chow, "Power System Oscillations: An Introduction to Oscillation
% Analysis and Control," 2nd Ed., New York, NY: Springer, 2025.

% network parameters
E = 1;
V = 1;
X = 0.1;
Pref = 0.9;
d0 = asin((Pref*X)/(E*V));
w0 = 2*pi*60;
K0 = ((E*V)/X)*cos(d0);

% droop/vsm model parameters
H = 2.5;                                      % inertia constant in seconds
mp = 0.05;                                    % droop gain = 20
Tp = 1/(2*pi*0.1);
Kw = 1/mp;
Tw = Tp;

G_fwd = tf([0,K0*w0],[1,0]);                  % forward path

%% vsm

G_vin_vsm = tf([0,1],[2*H,0]);                % inertia
G_dmp_vsm = tf([Kw*Tw,0],[Tw,1]);             % damping
G_drp_vsm = tf([0,1/mp],[Tp,1]);              % droop

% vsm control (with negative input, positive feedback convention)
T_vsm = feedback(G_vin_vsm,parallel(G_dmp_vsm,G_drp_vsm));
T_vsmlin = feedback(G_fwd,T_vsm);

%% drp - droop

G_drp_drp = tf(mp*[0,1],[0,1]);               % droop

% drp control (with negative input, positive feedback convention)
T_drplin = feedback(G_fwd,G_drp_drp);

%% bode

w = 2*pi*logspace(-2,3,256);
[m_vsm,p_vsm] = bode(T_vsmlin,w);
[m_drp,p_drp] = bode(T_drplin,w);

% eof
