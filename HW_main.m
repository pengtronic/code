close all;clear all;clc

% pc_1 = double(rgb2gray(imread('price_center20.JPG')));
% pc_2 = double(rgb2gray(imread('price_center21.JPG')));
% 
% Ix =  1/12*[-1,8,0,-8,1];
% Iy = Ix';
% n = 9;
% threshold = 9;
% 
% %% gradient image
% [grad_pc1_x,grad_pc1_y] = gradientImg(pc_1,Ix,Iy,n);
% [grad_pc2_x,grad_pc2_y] = gradientImg(pc_2,Ix,Iy,n);
% 
% %% eigen-image
% tic
% eigImage1 = getFeature(pc_1,grad_pc1_x,grad_pc1_y,n);
% eigImage2 = getFeature(pc_2,grad_pc2_x,grad_pc2_y,n);
% toc
% 
% %% get potential corners
% new_pc1 = padarray(eigImage1,[(n-1)/2,(n-1)/2]);
% new_pc2 = padarray(eigImage2,[(n-1)/2,(n-1)/2]);
% 
% tic
% [FakeCornerImage1,numFeature1] = NMS(new_pc1,threshold,n);
% [FakeCornerImage2,numFeature2] = NMS(new_pc2,threshold,n);
% toc
% 
% FakeCornerImage1 = FakeCornerImage1(5:end-4,5:end-4);
% FakeCornerImage2 = FakeCornerImage2(5:end-4,5:end-4);
% FakeCornerImage1 = padarray(FakeCornerImage1,[4,4]);
% FakeCornerImage2 = padarray(FakeCornerImage2,[4,4]);
% 
% %% get the corners coordinates
% [r1,c1] = find(FakeCornerImage1~=0);
% [r2,c2] = find(FakeCornerImage2~=0);
% 
% %% get the true coordinates
% [forRow1,forCol1] = forstner(grad_pc1_x,grad_pc1_y,r1,c1);
% [forRow2,forCol2] = forstner(grad_pc2_x,grad_pc2_y,r2,c2);
% 
% % draw box around the detected corners
% A1 = figure;
% imshow(uint8(pc_1));
% hold on
% for i = 1:length(r1)
%     rectangle('Position',[forCol1(i)-4,forRow1(i)-4,9,9],'linewidth',1.3);
% end
% hold off
% saveas(A1,'pc1_withboxes.png')
% 
% A2=figure;
% imshow(uint8(pc_2));
% hold on
% for i = 1:length(r2)
%     rectangle('Position',[forCol2(i)-4,forRow2(i)-4,9,9],'linewidth',1.3);
% end
% hold off
% saveas(A2,'pc2_withboxes.png')
% 
% %% match feature correspondences
% [rowImage1,actualCoord1] = image2matrix(pc_1,forRow1,forCol1);
% [rowImage2,actualCoord2] = image2matrix(pc_2,forRow2,forCol2);
% 
% matchingTresh = 0.81;
% 
% tic
% [matches1,comp1to2] = matchingCorrespondances(rowImage1,actualCoord1,...
%     rowImage2,actualCoord2,matchingTresh);
% toc
% 
% tic
% [matches2,comp2to1] = matchingCorrespondances(rowImage2,actualCoord2,...
%     rowImage1,actualCoord1,matchingTresh);
% toc
% 
% save('comp1to2.mat','comp1to2');
% save('comp2to1.mat','comp2to1');
% 
% B1 = figure;
% imshow(uint8(pc_1))
% hold on
% for i = 1:matches1
%     rectangle('Position',[comp1to2(i,2)-4,comp1to2(i,1)-4,9,9])
%     line(comp1to2(i,2:2:end),comp1to2(i,1:2:end));
% end
% hold off
% saveas(B1,'matches1.png');
% 
% B2 = figure;
% imshow(uint8(pc_2))
% hold on
% for i = 1:matches2
%     rectangle('Position',[comp2to1(i,2)-4,comp2to1(i,1)-4,9,9])
%     line(comp2to1(i,2:2:end),comp2to1(i,1:2:end));
% end
% hold off
% saveas(B2,'matches2.png');


comp1to2 = load('comp1to2.mat');
comp1to2 = comp1to2.comp1to2;

comp2to1 = load('comp2to1.mat');
comp2to1 = comp2to1.comp2to1;

image1 = comp1to2(:,[2,1]);
image2 = comp1to2(:,[4,3]);

image1_2 = comp2to1(:,[2,1]);
image2_2 = comp2to1(:,[4,3]);

n = size(comp1to2,1);

img1_homo = [image1,ones(n,1)];
img2_homo = [image2,ones(n,1)];

[correction,~,numInlier,InliersIndx,trials] = msac(image1,image2);
[correction_2,~,numInlier_2,InliersIndx_2] = msac(image1_2,image2_2);

%% plot inliers

% C1 = figure;
% imshow(uint8(pc_1))
% hold on
% for i = 1:size(corrected_inliers,1)
%     rectangle('Position',[corrected_inliers(i,1)-4,corrected_inliers(i,2)-4,9,9],'linewidth',1.3)
%     line(corrected_inliers(i,1:2:end),corrected_inliers(i,2:2:end));
% end
% hold off
% saveas(C1,'with_inliers1.png');
% 
% corrected_inliers_2 = correction_2(InliersIndx_2,:);
% C2 = figure;
% imshow(uint8(pc_2))
% hold on
% for i = 1:size(corrected_inliers_2,1)
%     rectangle('Position',[corrected_inliers_2(i,1)-4,corrected_inliers_2(i,2)-4,9,9],'linewidth',1.3)
%     line(corrected_inliers_2(i,1:2:end),corrected_inliers_2(i,2:2:end));
% end
% hold off
% saveas(C2,'with_inliers2.png');

%% DLT
n = sum(InliersIndx);
frank_inlier =[394.5105   28.2496  312.2762   23.8705
  456.2044   35.3020  371.6417   31.5326
  252.4681   43.6173  168.8819   36.0973
  499.4485   68.0894  414.2535   65.9403
  590.1378   71.6187  496.1098   70.1403
  203.5160   80.5850  120.2754   71.6366
  138.2292   87.5706   49.5814   78.2514
  547.1219  108.6379  459.2692  106.8368
  363.3282  139.7700  279.7123  133.9118
  392.6822  138.9419  310.2752  133.8262
  422.0414  140.4542  339.2797  135.3662
  527.9861  149.4840  441.2334  146.2361
  161.9967  155.7205   75.2140  148.0585
  581.3692  171.3043  491.6531  167.8693
  323.5059  177.3495  240.5171  171.3501
  224.9164  186.5186  141.0773  179.5731
  323.5662  214.7100  240.3804  209.7627
  531.4879  218.8143  443.9288  214.1195
  200.0841  224.8235  115.1582  218.2216
  180.6586  228.1911   94.7537  221.5587
  220.5821  232.5871  137.3847  226.4009
  117.6549  235.7831   29.6540  228.6434
  146.8847  235.1828   60.2433  228.0067
  149.0398  248.2631   61.6440  241.3699
  589.8542  251.5341  498.2713  247.4920
  201.4653  253.6421  116.1613  247.7843
  544.2633  260.6917  455.2819  255.1546
  102.1843  275.2517   12.3640  269.7928
  221.8109  276.8716  137.5799  270.4029
  549.5229  287.7658  461.0902  281.8616
  302.6891  290.9626  219.2703  284.7251
  121.9749  302.0203   33.4512  296.7910
  507.5203  308.4006  420.7172  301.6890
  217.1847  316.4222  132.1604  310.9379
  562.4485  343.9931  473.4473  335.9188
  517.6730  344.1804  429.9232  336.0672
  108.4590  346.0481   19.1448  342.1810
  419.8807  350.6071  335.8174  343.8906
  321.7687  360.8071  238.9324  354.6038
  507.7115  366.8530  420.6471  358.7272
  164.4420  366.5110   77.4884  362.8095
  246.0909  383.6736  162.1282  379.3601
  197.2281  386.4111  112.8099  382.3583
  229.6515  386.2302  146.0174  382.2382
  487.2968  397.6951  400.8905  388.5816
  492.4036  402.4422  406.1607  393.3753
  125.7713  396.2651   38.1558  393.8458
  389.8832  399.3729  305.9269  393.1355
  270.3272  398.0614  186.7239  393.1407
  423.8969  403.5803  339.2125  396.1834
  231.9851  401.3867  147.7875  395.9922
  461.5801  405.0554  376.8402  397.1324
  163.3377  402.9115   76.4086  399.8220
  195.4206  403.8498  108.8214  399.9112
  325.2085  404.4110  242.0455  397.9281
  216.8250  405.6250  132.1779  401.3337
  389.6164  416.0999  305.5668  409.4953
  257.8988  415.8371  173.5082  411.2389
  578.7690  422.9040  487.0557  412.1383
  349.1303  423.7512  265.6276  416.9538
  506.2875  426.9925  418.2948  416.9495
  518.2031  426.6740  430.2670  416.9297
  217.5882  426.7242  132.8567  422.7927
  523.4954  443.6506  436.0993  433.4136
  306.8086  440.4118  222.6472  434.4971];

frank_correct = [395.3682   28.2329  311.3910   23.8928
  456.7414   34.7744  371.0639   32.0731
  252.4913   44.0585  168.8704   35.6597
  500.5459   68.1414  413.0930   65.8950
  589.3160   71.0336  496.9853   70.7387
  204.2867   80.7248  119.5209   71.5025
  137.5118   88.2296   50.2884   77.6043
  548.0939  108.8702  458.2326  106.6053
  363.3282  139.7700  279.7123  133.9118
  393.5105  139.0829  309.4240  133.6891
  423.0207  140.3944  338.2625  135.4331
  529.0080  149.6727  440.1472  146.0503
  161.8071  156.2283   75.4045  147.5603
  582.4271  171.3752  490.5115  167.8045
  323.7187  177.5726  240.3039  171.1284
  225.2481  186.7433  140.7518  179.3531
  323.7138  215.4387  240.2349  209.0358
  532.2111  219.1026  443.1593  213.8296
  200.2543  225.0202  114.9920  218.0290
  180.6617  228.3878   94.7514  221.3658
  221.3444  232.8849  136.6340  226.1111
  117.9961  235.7653   29.3262  228.6621
  147.2011  235.1011   59.9368  228.0879
  148.9521  248.1616   61.7289  241.4686
  590.2513  252.4948  497.8426  246.5045
  201.4638  253.9602  116.1628  247.4717
  544.6186  261.0513  454.9019  254.7886
  102.1020  275.5035   12.4422  269.5481
  222.0984  276.6994  137.2969  270.5739
  550.2976  288.2863  460.2589  281.3336
  302.8081  290.9397  219.1508  284.7485
  122.0523  302.0258   33.3767  296.7860
  508.0677  308.6626  420.1357  301.4257
  217.1847  316.4222  132.1604  310.9379
  563.3106  344.1898  472.5196  335.7235
  517.9935  344.1411  429.5835  336.1097
  108.5757  346.0302   19.0332  342.1989
  420.3023  350.8193  335.3783  343.6793
  322.2242  360.7305  238.4731  354.6827
  508.1505  366.9797  420.1805  358.6013
  164.4278  366.6365   77.5005  362.6869
  246.3713  383.9238  161.8464  379.1146
  197.9156  386.3921  112.1370  382.3800
  230.2761  386.4987  145.3966  381.9769
  487.6488  397.4556  400.5243  388.8275
  492.9403  402.3096  405.5974  393.5139
  126.3585  396.3462   37.5897  393.7694
  390.0830  399.7784  305.7143  392.7295
  270.6073  398.1184  186.4436  393.0858
  424.0877  403.7072  339.0124  396.0567
  232.3282  400.8532  147.4581  396.5192
  462.2910  405.2561  376.0927  396.9339
  163.4136  402.8975   76.3351  399.8359
  195.0725  403.6871  109.1649  400.0691
  325.5432  404.1410  241.7121  398.1989
  217.1350  405.4717  131.8756  401.4859
  389.7804  416.3549  305.3932  409.2402
  257.8988  415.8371  173.5082  411.2389
  578.7690  422.9040  487.0557  412.1383
  349.3518  423.5249  265.4071  417.1811
  506.2551  426.7055  418.3356  417.2414
  518.4648  426.6537  429.9899  416.9523
  217.8731  426.5729  132.5796  422.9427
  524.1562  443.6128  435.3984  433.4571
  306.6964  440.1452  222.7662  434.7613];

% inlier_img1 = image1(InliersIndx,:);
% inlier_img2 = image2(InliersIndx,:);
n = 65;
inlier_img1 = frank_inlier(:,[1,2]);
inlier_img2 = frank_inlier(:,[3,4]);
corrected_inliers = frank_correct(:, [1,2]);
inlier_img1_homo = [inlier_img1,ones(n,1)];
inlier_img2_homo = [inlier_img2,ones(n,1)];
% corrected_inliers = correction(InliersIndx,[1,2]);


mean_img1 = mean(inlier_img1);
mean_img2 = mean(inlier_img2);
s2d_1 = sqrt(2)/norm(std(inlier_img1));
s2d_2 = sqrt(2)/norm(std(inlier_img2));

T_1 = [s2d_1,       0,         -mean_img1(1)*s2d_1;
    0,          s2d_1,     -mean_img1(2)*s2d_1;
    0,             0,                  1];

T_2 = [s2d_2,       0,         -mean_img2(1)*s2d_2;
    0,          s2d_2,     -mean_img2(2)*s2d_2;
    0,             0,                  1];

img1_normalized = inlier_img1_homo*T_1';
img2_normalized = inlier_img2_homo*T_2';

froNorm = arrayfun(@(idx) norm(img2_normalized(idx,:)),1:n)';
v = img2_normalized + [sign(img2_normalized(:,1)).*froNorm, zeros(n,2)];

A = zeros(2*n,9);
for i=1:n
    temp = v(i,:);
    Hv = eye(3) - 2*(temp'*temp)/(temp*temp');
    leftNull = Hv(2:end,:);
    A((2*i-1):(2*i),:) = kron(leftNull,img1_normalized(i,:));
end

[~,~,Av] = svd(A);
H_init = reshape(Av(:,end),3,3)';
H_init = inv(T_2)*H_init*T_1;
H_init = reshape(deparameterize(parameterize(H_init)),3,3)';

lambda = 1e-3;

%% Sparse Matrix and LM
Ai = zeros(2*n,8);
Bi_p = zeros(2*n,2*n);
Bi_pp = zeros(2*n,2*n);
cost_LM = [];
H_p = eye(3);
H_pp = H_init;
[cst,~,~] = calCost(H_p,H_pp,corrected_inliers,inlier_img1,inlier_img2);
cost_LM = [cost_LM,cst];

for iter = 1:100
    [~,vec_eps_p,vec_eps_pp] = calCost(H_p,H_pp,corrected_inliers,inlier_img1,inlier_img2);
    
    projected_img1_homo = H_p*[corrected_inliers,ones(n,1)]';
    projected_img2_homo = H_pp*[corrected_inliers,ones(n,1)]';
    
    for i = 1:n
        Ai((2*i-1):(2*i),:) = solveForAi(projected_img2_homo(:,i),H_pp);
        Bi_p((2*i-1):(2*i),(2*i-1):(2*i)) = solveForBi(projected_img1_homo(:,i));
        Bi_pp((2*i-1):(2*i),(2*i-1):(2*i)) = solveForBi(projected_img2_homo(:,i));
    end
    
    Upp = Ai'*Ai;
    V = Bi_p'*Bi_p+Bi_pp'*Bi_pp;
    Wpp = Ai'*Bi_pp;
    
    h = parameterize(H_pp);
    x_hat = vec(corrected_inliers',n);
    param_vect = [h,x_hat'];
    
    while(1)
        aug_V = V + lambda*eye(2*n);
        aug_Upp = Upp + lambda*eye(8);
        Spp = aug_Upp - Wpp*inv(aug_V)*Wpp';
        
        eps_a = Ai'*vec_eps_pp;
        eps_b = Bi_p'*vec_eps_p+Bi_pp'*vec_eps_pp;
        e_pp = eps_a - Wpp*inv(aug_V)*eps_b;
        delta_a = Spp\e_pp;
        delta_b = inv(aug_V)*(eps_b-Wpp'*delta_a);
        
        param_vect_update = param_vect + [delta_a',delta_b'];
        H_temp = reshape(deparameterize(param_vect_update(1:8))',3,3)';
        x_hat_temp = [param_vect_update(9:2:end);param_vect_update(10:2:end)]';
        [cost_temp,~,~] = calCost(H_p,H_temp,x_hat_temp,inlier_img1,inlier_img2);
        
        if cost_temp < cost_LM(iter)
            H_pp = H_temp;
            corrected_inliers = x_hat_temp;
            cost_LM = [cost_LM,cost_temp];
            lambda = 0.1*lambda;
            break;
        else
            lambda = 10*lambda;
        end
    end
    
    if cost_LM(iter) - cost_LM(iter+1)<1e-5
        break;
    end
end

fig = figure;
plot(0:length(cost_LM)-1,cost_LM,'-*');grid on
xlabel('number of iteration','fontSize',20);
ylabel('cost','fontSize',20);
title('cost function','fontSize',20);
saveas(fig,'Cost.png');

