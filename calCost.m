function [error,vec_eps_p,vec_eps_pp] = calCost(P,P_p,X3d,inlier_img1,inlier_img2)

n = size(X3d,1);

eps_p = inlier_img1'-homo2inhomo(P*X3d');
eps_pp = inlier_img2'-homo2inhomo(P_p*X3d');

vec_eps_p = reshape(eps_p,2*n,1);
vec_eps_pp = reshape(eps_pp,2*n,1);

error = vec_eps_p'*vec_eps_p + vec_eps_pp'*vec_eps_pp;