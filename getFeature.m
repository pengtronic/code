function y = getFeature(img,gradientImage1,gradientImage2,n)

new_img = zeros(size(img));
Ixx = gradientImage1.^2;
Iyy = gradientImage2.^2;
Ixy = gradientImage1.*gradientImage2;

N = zeros(2,2);

for i = 1:size(new_img,1)
    for j = 1:size(new_img,2)
        N(1,1) = sum(sum(Ixx(i:i+n-1, j:j+n-1)))/n^2;
        N(1,2) = sum(sum(Ixy(i:i+n-1, j:j+n-1)))/n^2;
        N(2,1) = N(1,2);
        N(2,2) = sum(sum(Iyy(i:i+n-1, j:j+n-1)))/n^2;
        new_img(i,j) = min(eig(N));
    end
end

y = new_img;