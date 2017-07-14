function cross_term = expdist_matlab(A,B)

    m = size(A.points,1);
    n = size(B.points,1);
    cross_term = 0;
    
    for i=1:m
            curApoint = repmat(A.points(i,:),n,1);
            curAsigma = repmat(A.sigma(i),n,1);
            curCross = exp(-sum((curApoint-B.points).^2,2)./(curAsigma+B.sigma));
            cross_term = cross_term + sum(curCross(:));
    end

end