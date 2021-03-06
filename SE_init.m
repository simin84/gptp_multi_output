function hyp = SE_init( d_input,~)
% SE_init -- Produce the initial hyperparameters for SE kernel in the most   
%            commonly-used method.
% 
% Syntax:
%   [...] = SE_init(d_input,~)
%
% In
%    d_input   -  dimension of input space
%       ~      -  any other arbitrary input
%
% Out
%      hyp     - If there are two inputs, hyp means the number of hypers.
%                If there is only one input, hyp means the initial hypers 
%
% Remark:  the choice of prior distribution on the initial hyperparameters 
% may play a vital rule in the parameter estimation and the performance of 
% GPR model. You can design a proper initialisation approach for a specific
% kernel based on the details of problem.
%
% Copyright:  Magica Chen 2017/05/19
%     email:  sxtpy2010@gmail.com
%
% Reference :
%    [1] Chen, Zexun, and Bo Wang. "How priors of initial hyperparameters 
%        affect Gaussian process regression models." arXiv preprint 
%        arXiv:1605.07906 (2016).
%%
if nargin >3 || nargin < 1
    error('The number of input must be less than 3 and more than 1')
end

if nargin==2 
    hyp = 1 + d_input*1;        % report the number of hyp
    return 
end              % report number of parameters

n_parameter = 1 + d_input*1;    % The number of parameter in the kernel
hyp = rand(n_parameter,1);      % This is the most commonly-used method
end

