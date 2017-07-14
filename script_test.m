%% inspecting bhattacharya distance

load('../hpc17/data/particles_nph5000_dol100_tr0_nmN50.mat')
nParticles = numel(Particles);

for m=1:nParticles-1
    for n=m+1:nParticles

    disp(['Evaluating Bhatt for particles# ' num2str(m) ' and ' num2str(n) '.']);
    tic
    idxS = m;
    idxM = n;
    S.points = Particles{1,idxS}.coords(:,1:2);
    S.sigma  = Particles{1,idxS}.coords(:,5).^2;
    M.points = Particles{1,idxM}.coords(:,1:2);
    M.sigma  = Particles{1,idxM}.coords(:,5).^2;

    trueAngleR(m,n) = Particles{1,idxM}.angle - Particles{1,idxS}.angle;
    trueAngleD(m,n) = rad2deg(trueAngleR(m,n));

    startAngle = 0;
    endAngle = 2*pi;

    angle = linspace(startAngle, endAngle,2*360);

    for i=1:numel(angle)

        bhatt_dist(i) = expdist_cuda(M, S, angle(i), 0, 0);

    end

    [maxVal maxIDX] = max(bhatt_dist);
    estAngleR(m,n) = angle(maxIDX);
    estAngleD(m,n) = rad2deg(estAngleR(m,n));

    bhatt_dist_vec{m,n} = bhatt_dist;
    clearvars bhatt_dist;

    toc
    end
end

save('test/estAngleD', 'estAngleD');
save('test/trueAngleD', 'trueAngleD');
save('test/bhatt_dist_vec', 'bhatt_dist_vec');

%%
k=1;
for i=1:nParticles-1
   for j=(i+1):nParticles
       eAngleD_vec(k) = estAngleD(i,j);
       tAngleD_vec(k) = trueAngleD(i,j);
       k=k+1;
   end
end

error = wrapTo180(tAngleD_vec - eAngleD_vec);
h(2) = histogram(error,'BinWidth',0.1);
title('Distribution of error for Bhatt. cost function')
xlabel('degree')
