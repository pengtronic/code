function Bi = solveForBi(x3d,P)

x3d = deparameterize(x3d);

x2dh = P*x3d;

% solve for dx_hat/dX_bar
dx_hat_dx_bar = [(P(1,1)*x2dh(3)-P(3,1)*x2dh(1))/x2dh(3)^2, (P(1,2)*x2dh(3)-P(3,2)*x2dh(1))/x2dh(3)^2, ...
    (P(1,3)*x2dh(3)-P(3,3)*x2dh(1))/x2dh(3)^2, (P(1,4)*x2dh(3)-P(3,4)*x2dh(1))/x2dh(3)^2; ...
    (P(2,1)*x2dh(3)-P(3,1)*x2dh(2))/x2dh(3)^2, (P(2,2)*x2dh(3)-P(3,2)*x2dh(2))/x2dh(3)^2, ...
    (P(2,3)*x2dh(3)-P(3,3)*x2dh(2))/x2dh(3)^2, (P(2,4)*x2dh(3)-P(3,4)*x2dh(2))/x2dh(3)^2];


% sove for dX_bar/dX_hat
param = parameterize(x3d);
nv = norm(param,'fro')/2;
a = -sinc(nv/pi)/4*param;
if nv == 0
    b = 0.5*eye(length(param));
else
    b = 0.5*sinc(nv/pi)*eye(length(param))+(cos(nv)/nv-sin(nv)/(nv^2))/(8*nv)*(param'*param);
end
dxdx = [a;b];

Bi = dx_hat_dx_bar*dxdx;