clear all;clc

m = 2000;
n = 2000;

% change this, smaller coef result in bigger error
coef = 0.1;

A.points = rand(m,2);
B.points = rand(n,2);

A.sigma = rand(m,1);
B.sigma = rand(n,1);

score_cpu = expdist(A, B, 0, 0, 0);
score_gpu = expdist_mex_cuda(A.points, B.points, A.sigma, B.sigma);


score_error = abs(score_cpu - score_gpu);