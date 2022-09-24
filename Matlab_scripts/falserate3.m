function ratio = falserate3(x,PairModel)
    
    minid = find(PairModel.mu==median(PairModel.mu));
    [~,maxid] = max(PairModel.mu);

    alpha = PairModel.ComponentProportion(minid);
    beta = PairModel.ComponentProportion(maxid);
    
    Phi_min = normcdf(x,PairModel.mu(minid),sqrt(PairModel.Sigma(minid)));
    Phi_plus = normcdf(x,PairModel.mu(maxid),sqrt(PairModel.Sigma(maxid)));

    ratio = alpha*(1-Phi_min)/(beta*(1-Phi_plus)+alpha*(1-Phi_min));
end
    