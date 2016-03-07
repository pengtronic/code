function [matches,y] = matchingCorrespondances(img1,actualCoord1,img2,actualCoord2,corrTresh)

a = size(img1,1);
b = size(img2,1);
maxCorr = zeros(a,b);

for i = 1:a
    repRow = repmat(img1(i,:),b,1);
    maxCorr(i,:) = arrayfun(@(idx) corr2(repRow(idx,:),img2(idx,:)),1:b);
end

[val,idx] = max(maxCorr,[],2);
matches = find(val>corrTresh);

val = val(matches);
idx = idx(matches);

data = zeros(b,3);
data(:,1) = 1:b;

for i = 1:length(idx)
    if data(idx(i),2)<val(i)
        data(idx(i),2) = val(i);
        data(idx(i),3) = matches(i);
    end
end

data_update = data(data(:,2)>0,:);
matches = size(data_update,1);

corresp = zeros(matches,4);

for i = 1:matches
    matchedImage1 = actualCoord1(data_update(i,3),:);
    matchedImage2 = actualCoord2(data_update(i,1),:);
    corresp(i,:) = [matchedImage1,matchedImage2];
end

y = corresp;