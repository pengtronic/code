function [y,numFeature] = NMS(img,threshold,n)

for i = 1:size(img,1)-(n-1)
    for j = 1:size(img,2)-(n-1)
        img(i:i+n-1,j:j+n-1) = uniqueMax(img(i:i+n-1,j:j+n-1),threshold);
    end
end

y = img;
numFeature = sum(sum(y>0));