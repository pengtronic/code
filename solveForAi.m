function Ai = solveForAi(xi,P)

xdp = deparameterize(xi);

x = P*xdp;

% solve for dx/dp
w = x(end);
x = homo2inhomo(x);
dxdp = [xdp'/w,zeros(1,4),-x(1)/w*xdp';
        zeros(1,4),xdp'/w,-x(2)/w*xdp';];

% solve for dp_bar/dp_hat
p_hat = parameterize(P);
nv = norm(p_hat,'fro')/2;
a = -sinc(nv/pi)/4*p_hat;
if nv == 0
    b = 0.5*eye(length(p_hat));
else
    b = 0.5*sinc(nv/pi)*eye(length(p_hat))+(cos(nv)/nv-sin(nv)/(nv^2))/(8*nv)*(p_hat'*p_hat);
end
dpdp = [a;b];

Ai = dxdp*dpdp;