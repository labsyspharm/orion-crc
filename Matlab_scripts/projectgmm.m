function projectedgmm = projectgmm(gmdistfull,projplane,centermean);
    %give projection plane as a matrix of column vectors
    
    for i = 1:size(gmdistfull.mu,1)
       mu(i,:) =  projplane'*(gmdistfull.mu(i,:) - centermean)';
       sigma(:,:,i) = projplane'*gmdistfull.Sigma(:,:,i)*projplane;
    end
    projectedgmm = gmdistribution(mu,sigma,gmdistfull.ComponentProportion);
end