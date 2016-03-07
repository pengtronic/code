function v_tilda = parameterize(v)

[a,b] = size(v);

v = reshape(v',1,a*b);
v = v/norm(v);

a = v(1);
b = v(2:end);

v_tilda = 2*b/(sinc(acos(a)/pi));

if norm(v_tilda,'fro') > pi
    v_tilda = (1-2*pi*ceil((norm(v_tilda,'fro')-pi)/(2*pi))/norm(v_tilda,'fro'))*v_tilda;
end

end