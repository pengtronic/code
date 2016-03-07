function v = deparameterize(v_tilda)

v = [cos(norm(v_tilda,'fro')/2),sinc(norm(v_tilda,'fro')/(2*pi))/2*v_tilda]';
