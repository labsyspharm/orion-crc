function gmm = skewSMGM(data,kini)
flag = 0;
options = statset('Maxiter',1000);
tic
gmm = fitgmdist(data,kini,'Options',options);
toc
k = kini;
kmax = 30; %stops fitting after this many k is reached

figure() %for tracking progress
grid on

cutoff = 0.3; %acceptable skewness of theoretical single-population
while flag==0 %loop tontinues until skewness is sufficiently small
    tic
    skewvec = indskewness(gmm,data);
    
    hold on
    scatter(k*ones(numel(skewvec),1),skewvec,'filled')
    drawnow
    
    %make adjusted cutoff for 2 standard errors of skewness, for each
    %univariate dimension
    adjcutoff = 2*sqrt(6)./sqrt(gmm.ComponentProportion*size(data,1))+cutoff;
    skewcomps = skewvec>adjcutoff; %which components are skew?
    badskew = any(skewcomps);
    if badskew %condition for skewness is met
        k = k+1;
        disp(['trying ' num2str(k) ' components'])
        %define initial guess
        guess = split_guess(gmm,skewvec,data);
        gmm = fitgmdist(data,k,'Options',options,'Start',guess);
    else
        skewvec = indskewness(gmm,data);
        scatter(k*ones(numel(skewvec),1),skewvec,'filled')
        drawnow
        flag=1;
    end
    if k == kmax
        skewvec = indskewness(gmm,data);
        scatter(k*ones(numel(skewvec),1),skewvec,'filled')
        drawnow
        flag=1;
    end
    toc
end

[coeff,score,~] = pca(data);
figure,dscatter(score(:,1),score(:,2))
center = mean(data);
projgmm = projectgmm(gmm,coeff(:,[1 2]),center);
hold on
levellist = [0.001 0.005 0.01 0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
fcontour(@(x1,x2)pdf(projgmm,[x1 x2]),[xlim ylim],'LevelList',levellist,'Linecolor','r')
scatter((gmm.mu-center)*coeff(:,1),(gmm.mu-center)*coeff(:,2),'filled')
end

%function to define initial guess of k+1 components using the mean vs.
%median estimates to define lengthscale and direction of perturbation
function splitgmm = split_guess(gmm,skewvec,data)
    k = gmm.NumComponents;
    [~,splitid]= max(skewvec);
    postprob = posterior(gmm,data);
    randdraw = rand(size(data,1),1);
    sampleid = randdraw<postprob(:,splitid);
    sample = data(sampleid,:);
    sampleskew = skewness(sample);
    
    splitgmm.mu = gmm.mu;
    mushift = 2*sampleskew.*diag(sqrt(gmm.Sigma(:,:,splitid)))';
    splitgmm.mu(splitid,:) = gmm.mu(splitid,:) - mushift;
    splitgmm.mu(k+1,:) = gmm.mu(splitid,:) + mushift;
    
    splitgmm.Sigma = gmm.Sigma;
    splitgmm.Sigma(:,:,k+1) = gmm.Sigma(:,:,splitid);
    
    splitgmm.ComponentProportion = gmm.ComponentProportion;
    splitgmm.ComponentProportion(splitid) = 0.67*gmm.ComponentProportion(splitid);
    splitgmm.ComponentProportion(k+1) = 0.33*gmm.ComponentProportion(splitid);
end

    
    
