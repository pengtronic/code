function Xpi = calc3D(image1, image2, symbols, eq_coef, P_p, F_dlt_p)

T = [1, 0, -image1(1)
    0, 1, -image1(2)
    0, 0, 1];

Tp = [1, 0, -image2(1)
    0, 1, -image2(2)
    0, 0, 1];

Fs = inv(Tp')*F_dlt_p*inv(T);
e_prime = null(Fs'); e_prime = e_prime/sqrt(e_prime(1)^2+e_prime(2)^2);
e = null(Fs); e = e/sqrt(e(1)^2+e(2)^2);

R = [e(1), e(2), 0
    -e(2), e(1), 0
    0,     0,  1];

Rp = [e_prime(1), e_prime(2), 0
    -e_prime(2), e_prime(1), 0
    0           0      1];

Fs = Rp*Fs*R';
a = Fs(2,2);
b = Fs(2,3);
c = Fs(3,2);
d = Fs(3,3);
f = e(3);
fp = e_prime(3);
subNum = [a,b,c,d,f,fp];

numeric_coef = subs(eq_coef,symbols,subNum);
t = roots(double(numeric_coef));
t = real(t);

sol_check = t.^2./(1+f^2*t.^2)+(c*t+d).^2./((a*t+b).^2+fp^2*(c*t+d).^2);
[~,idx] = min(sol_check);
t = t(idx);
l = [t*f, 1, -t]';
lp = [-fp*(c*t+d), a*t+b, c*t+d]';
x_hat = [-l(1)*l(3), -l(2)*l(3), l(1)^2+l(2)^2];
x_hatp = [-lp(1)*lp(3), -lp(2)*lp(3), lp(1)^2+lp(2)^2];

x_hat = inv(T)*R'*x_hat';
x_hatp = inv(Tp)*Rp'*x_hatp';

L = F_dlt_p*x_hat;
lperp = [-L(2)*x_hatp(3), L(1)*x_hatp(3), L(2)*x_hatp(1)-L(1)*x_hatp(2)]';

pl = P_p'*lperp;

Xpi = [pl(4)*x_hat(1), pl(4)*x_hat(2), pl(4)*x_hat(3),...
    -(pl(1)*x_hat(1)+pl(2)*x_hat(2)+pl(3)*x_hat(3))];

end
