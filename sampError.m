function [error,correction] = sampError(img1_inhomo,img2_inhomo,F, Aif)


J = [img2_inhomo(1)*F(1,1)+img2_inhomo(2)*F(2,1)+F(3,1),...
       img2_inhomo(1)*F(1,2)+img2_inhomo(2)*F(2,2)+F(3,2),...
       img1_inhomo(1)*F(1,1)+img1_inhomo(2)*F(1,2)+F(1,3),...
       img1_inhomo(1)*F(2,1)+img1_inhomo(2)*F(2,2)+F(2,3)];

lambda = -Aif/(J*J');

delta = J'*lambda;

error = delta'*delta;

correction = [img1_inhomo,img2_inhomo] + delta';

end