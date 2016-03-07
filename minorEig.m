function lambda = minorEig(w1,w2,n)

y = zeros(2,2);
y(1,1) = sum(sum(w1.^2))/n^2;
y(1,2) = sum(sum(w1.*w2))/n^2;
y(2,1) = y(1,2);
y(2,2) = sum(sum(w2.^2))/n^2;

lambda = min(eig(y));