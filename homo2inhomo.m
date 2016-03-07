function inhomo = homo2inhomo(homo)

if size(homo,1)==3
    inhomo = [homo(1,:)./homo(3,:);homo(2,:)./homo(3,:)];
elseif size(homo,1)==4
    inhomo = [homo(1,:)./homo(4,:);homo(2,:)./homo(4,:);homo(3,:)./homo(4,:)];
end