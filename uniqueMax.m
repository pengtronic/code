function y = uniqueMax(A,threshold)

[r,c] = find(A==max(max(A)));

B = zeros(size(A));
maxA = max(A(:));
if maxA<threshold
    y = zeros(size(A));
else
    for i = 1:length(r)
        a = r(i); b = c(i);
        B(a,b)=max(max(A));
        y = B;
    end
end
