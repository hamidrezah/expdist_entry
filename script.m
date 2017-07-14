load('dataset.mat');

A = Particles{1,1}.coords(:,1:2);
B = Particles{1,2}.coords(:,1:2);

scale_A = Particles{1,1}.coords(:,5);
scale_B = Particles{1,2}.coords(:,5);

% tic
% [score_cpu, grad_cpu] = GaussTransform(A', B', scale);
% toc
tic
[score_gpu] = expdist_mex_cuda(A', B', scale_A, scale_B);
toc

% disp(score_cpu)
disp(score_gpu)

%%
load('dataset.mat');

A.points = Particles{1,1}.coords(:,1:2);
B.points = Particles{1,2}.coords(:,1:2);

A.sigma = Particles{1,1}.coords(:,5).^2;
B.sigma = Particles{1,2}.coords(:,5).^2;

tic
D = expdist(A, B, 0, 0, 0);
toc
%%
clear all;clc

load('~/../../tudelft/ls/staff-bulk/tnw/IST/QI/users/hheydarian/heidarian9/test/final_best_result/pyramid.mat')

nlayers = numel(layers);
cpu_t = zeros(1,nlayers);
gpu_t = zeros(1,nlayers);
score_error = zeros(1,nlayers);

for i=1:nlayers
    
    A.points = layers(i).node(1).left.points;
    B.points = layers(i).node(1).right.points;
    
    A.sigma = layers(i).node(1).left.sigma.^2;
    B.sigma = layers(i).node(1).right.sigma.^2;
    
    tic;
    score_cpu(i) = expdist(A, B, 0, 0, 0);
    cpu_t(i) = toc;
    
    
    tic
    score_gpu(i) = expdist_mex_cuda(A.points, B.points, A.sigma, B.sigma);
    gpu_t(i) = toc;
    
%     tic
%     score_matlab(i) = expdist_matlab(A,B);
%     matlab_t(i) = toc;
    
%     score_error(i) = abs(score_cpu - score_gpu);
    
    display(['layers ' num2str(i) ' done.']);
    
end
%%
for i=1:nlayers

    A = layers(i).node(1).left.points;
    B = layers(i).node(1).right.points;

    particleSize(i) = 0.5*(size(A,1)+size(B,1));
    
end

score_error = abs(score_cpu - score_gpu);

plot(log10(particleSize),log10(cpu_t),'o')
hold on
plot(log10(particleSize),log10(gpu_t),'x')
legend('cpu','gpu')
xlabel('average localizations per particle (log)')
ylabel('time in seconds (log)')
title('Bhattacharya distance running time')

figure,plot(particleSize, score_error);
xlabel('average localizations per particle (log)')
ylabel('absolute error')
title('score difference (cpu vs gpu)')
% 
% figure,plot(particleSize, grad_error);
% xlabel('average localizations per particle (log)')
% ylabel('maximum absolute error')
% title('gradient difference (cpu vs gpu)')
%%
load('~/../../tudelft/ls/staff-bulk/tnw/IST/QI/users/hheydarian/heidarian9/test/final_best_result/pyramid.mat')

scale = 0.01;

for i=1:10
    
    A = layers(2).node(i).left.points;
    B = layers(2).node(i).right.points;
    
    tic;
    [score_cpu, grad_cpu] = GaussTransform(A', B', scale);
    cpu_t2(i) = toc;
    
    tic
    [score_gpu, grad_gpu] = gmmreg_mex_cuda(A', B', scale);
    gpu_t2(i) = toc;
    
    
end

cpu_avg2 = mean(cpu_t2);
gpu_avg2 = mean(gpu_t2);
%%
clear all;clc
m = 2000;
n = 2000;
A.points = rand(m,2);
B.points = rand(n,2);

A.sigma = rand(m,1);
B.sigma = rand(n,1);

score_cpu = expdist(A, B, 0, 0, 0);

score_gpu = expdist_mex_cuda(A.points', B.points', A.sigma', B.sigma');

% [score_cpuG,~] = GaussTransform(A.points', B.points', 0.01);

score_error = abs(score_cpu - score_gpu);
