function [varargout] = mv_gptp_sample(cov_x,cov_y,x, noise_level,hyp,nu)
% This function is to generate a sample from mGP(0,C,B) or genearte a sample
% from mTP(nu,0,C,B), where C is the selected kernel, B is the covariance
% of output and nu is the degree of freedom
%   Formula
%     matrix GP sample:
%     If gn \sim N(0,1), C is the kernel GP,which can be written as the SVD
%     decompostion, namely, C = u*s*v', thus, z_gp = u*sqrt(s)*gn is a
%     sample of GP(0,C), since E(z_gp)=0, Cov(z_gp,z_gp')=
%     (u*sqrt(s))(u*sqrt(s)' = C;
%
%     matrix TP sample:
%     If tn \sim t(nu),which the mean of t distribution is 0 and the
%     variance is nu/(nu-2), C is the kernel GP,which can be written as the
%     SVD decompostion, namely, C = u*s*v', thus,
%     z_tp = (nu/(nu-2))^(-1/2)*u*sqrt(s)*tn is a sample of TP(nu,0,C),
%     since E(z_tp)=0; Cov(z_tp,z_tp') = (nu/(nu-2))^(-0.5))*(U*sqrt(s)*
%                                        (nu/(nu-2))*((nu/(nu-2))^(-0.5)*U*sqrt(s))'
%                                      = (U*sqrt(s))(U*sqrt(s))'=C
%   Usage:
%     disp('Usage: [mv_gp_sample] = gptp_sample(cov_x,cov_y,x,hyp);')
%     disp('   or: [mv_tp_sample] = gptp_sample(cov_x,cov_y,x,hyp,nu);')
%     disp('   or: [mv_gp_sample mv_tp_sample] = gptp_sample(cov_x,cov_y,x,hyp,nu);')
%
%   Input:
%     cov_x: the kernel or covariance function of x
%     cov_y: covariance of outputs
%     noise_level: noisy kernel
%     x    : the points which is used to evaluate the cov
%     hyp  : the enough hypers, which is used to evaluate the cov
%     nu   : the degree of freedom of student t distribution
%
%   Output:
%     mv_gp_sample and mv_tp_sample
%
%   Copyright Magica Chen, 2018/10/28
%      email: sxtpy2010@gmail.com

if nargin < 4 || nargin >6
    disp('Usage: [mv_gp_sample] = mv_gptp_sample(cov_x,cov_y,x,hyp);')
    disp('   or: [mv_tp_sample] = mv_gptp_sample(cov_x,cov_y,x,hyp,nu);')
    disp('   or: [mv_gp_sample tp_sample] = mv_gptp_sample(cov,x,hyp,nu);')
    return
end

n = size(x,1);  %d = size(cov_y,1);
C = feval(cov_x, hyp, x);B = cov_y;
[u,s,~] = svd(C + noise_level * ones(size(C)));  %SVD decomposition, BC=usv'

if nargin == 5
    gn = mvnrnd([0;0],B,n);  % Genearate a sample from multi-normal distribution
    z_gp = u*sqrt(s)*gn;
    varargout = {z_gp};
end

if nargin == 6
    tn = mvtrnd(B,nu,n); % Genearate a sample from multi-student t distribution with
    z_tp = (nu/(nu-2))^(-0.5).*u*sqrt(s)*tn;
    
    if nargout < 2
        varargout = {z_tp};
    else
        
        gn = mvnrnd([0;0],B,n);  % Genearate a sample from multi-normal distribution
        z_gp = u*sqrt(s)*gn;
        varargout = {z_gp,z_tp};
    end
end

