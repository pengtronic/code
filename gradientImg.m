function [Gx,Gy] = gradientImg(img,kernelX,kernelY,m)

Padx = padarray(img,[0,2]);
Pady = padarray(img,[2,0]);

Gx = padarray(conv2(Padx,kernelX,'valid'),[m,m]);
Gy = padarray(conv2(Pady,kernelY,'valid'),[m,m]);