function [correction,consensusMinCost,numInlier,InliersIndx,trials] = msac(image1,image2)

n = size(image1,1);
img1_homo = [image1,ones(n,1)];
img2_homo = [image2,ones(n,1)];

consensusMinCost = Inf;
MaxTrials = Inf;
trials = 0;
threshold = 0;
tolerance = chi2inv(0.95,1);
% consensusMinModel = 0;
p = 0.99;
tol = 10^-100;

syms a1 a2 a3 a4 a5 a6 a7 a8 a9
F1_sym = [ a1, a2, a3; a4, a5, a6; a7, a8, a9 ];
syms b1 b2 b3 b4 b5 b6 b7 b8 b9
F2_sym = [ b1, b2, b3; b4, b5, b6; b7, b8, b9 ];
syms alfa
F_sym = alfa * F1_sym + F2_sym;
g = det( F_sym );
coef = collect( g, alfa );

while((trials < MaxTrials) && (consensusMinCost > threshold))
    trials = trials + 1;
    
    samples = randperm(n,7);
    sample_img1 = img1_homo(samples,:);
    sample_img2 = img2_homo(samples,:);
    
    A = zeros(7,9);
    
    %calculate F
    for i = 1:7
        A(i,:) = kron(sample_img2(i,:),sample_img1(i,:));
    end
    null_A = null(A);

    equation = subs(coef,[a1, a2, a3, a4, a5, a6, a7, a8, a9, ...
        b1, b2, b3, b4, b5, b6, b7, b8, b9],[null_A(:,1)',null_A(:,2)']);
    
    [c,~] = coeffs(equation,alfa);
    r = roots(double(c));
    r = real(r(tol>abs(imag(r))));
    
    solution_error = zeros(length(r),n);
    temp_correction = zeros(n,4);
    corrected = cell(length(r),1);
    
    F1 = reshape(null_A(:,1),3,3)';
    F2 = reshape(null_A(:,2),3,3)';
    
    for i = 1:length(r)
        F = r(i)*F1+F2;
        F = F/norm(F,'fro');
        f = reshape(F',9,1);
        for j = 1:n
            Aif = kron(img2_homo(j,:),img1_homo(j,:))*f;
            [solution_error(i,j),temp_correction(j,:)] = sampError(image1(j,:), image2(j,:), F, Aif);
        end
        corrected{i} = temp_correction;
    end

    cost_msac=zeros(length(r),1);
    
    for a = 1:length(r)
        se = solution_error(a,:);
        for i=1:n
            if se(i)<=tolerance
                cost_msac(a) = cost_msac(a) + se(i);
            else
                cost_msac(a) = cost_msac(a) + tolerance;
            end
        end
    end
    
    [cost, idx] = min(cost_msac);
    sampsonError = solution_error(idx,:);
    
    if cost < consensusMinCost
        correction = corrected{idx};
        consensusMinCost = cost;
        numInlier = sum(sampsonError<tolerance);
        InliersIndx = sampsonError<tolerance;
        w = numInlier/n;
        MaxTrials = log10(1-p)/log10(1-w^7)
%         sum_sampson = sum(sampsonError)
    end
end
