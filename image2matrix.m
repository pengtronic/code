function [y,updatedCoord] = image2matrix(img,row,col)

n = 19;
[height,width] = size(img);
row_double = round(row);
col_double = round(col);
y = zeros(length(row),n^2);

m = floor(n/2);

for i = 1:length(row_double)
    if row_double(i)-m<=0 || row_double(i)+m>=height || col_double(i)-m<=0 || col_double(i)+m>=width
        continue;
    end
    temp = img((row_double(i)-m):(row_double(i)+m),(col_double(i)-m):(col_double(i)+m));
    y(i,:) = temp(:)';
end

nonZeroRow = (y(:,1)~=0);
y = y(nonZeroRow,:);

updatedCoord = [row(nonZeroRow),col(nonZeroRow)];