
tol = 1e-7;  % numerical tolerance

a_mat(abs(a_mat) < tol) = 0;

b_pm(abs(b_pm) < tol) = 0;
b_vr(abs(b_vr) < tol) = 0;

c_p(abs(c_p) < tol) = 0;
c_pm(abs(c_pm) < tol) = 0;
c_spd(abs(c_spd) < tol) = 0;
c_t(abs(c_t) < tol) = 0;
c_v(abs(c_v) < tol) = 0;

smib.a_mat = a_mat;
smib.b_pm = b_pm;
smib.b_vr = b_vr;
smib.c_p = c_p;
smib.c_pm = c_pm;
smib.c_spd = c_spd;
smib.c_t = c_t;
smib.c_v = c_v;

if exist('b_pr','var')
    b_pr(abs(b_pr) < tol) = 0;
    smib.b_pr = b_pr;
end

save datalaag_smib.mat smib

% eof