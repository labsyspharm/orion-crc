function [cutoff,poscells,GMMmodel] = CycIF_findcutoff(markersample,minval,K,FDR) 

%%input a vector of a particular marker, a minimum marker value, and chosen False Discovery Rate (FDR);
%  "minval" is for the purpose that some samples have a significant bump for
%  background, for whatever reason, so they should be cut if we stick to 2
%  distributions

    warning('off','all')
    
    tic
    GMMmodel = fitgmdist(markersample(markersample>minval),K,'replicates',10);
    toc
    
    [~,sortID]= sort(GMMmodel.mu);
    minid = sortID(1);
    maxid = sortID(2);
    %[~,minid] = min(GMMmodel.mu);
    %[~,maxid] = max(GMMmodel.mu);
    
    peak_min = normpdf(GMMmodel.mu(minid),GMMmodel.mu(minid),sqrt(GMMmodel.Sigma(minid)));
    peak_plus = normpdf(GMMmodel.mu(maxid),GMMmodel.mu(maxid),sqrt(GMMmodel.Sigma(maxid)));
    
    
    if GMMmodel.ComponentProportion(maxid)*peak_plus>GMMmodel.ComponentProportion(minid)*peak_min
        searchrange = prctile(markersample,2):0.01:prctile(markersample,70);
    else
        searchrange = prctile(markersample,10):0.01:prctile(markersample,98);
    end
    
    objfunc = searchrange;
    
    for searchid = 1:size(searchrange,2)
        objfunc(searchid) = (falserate(searchrange(searchid),GMMmodel)-FDR)^2;
    end
    
    
    %figure,plot(searchrange,log(objfunc)) %this is a diagnostic line
    
    [~,minobj] = min(objfunc);
    cutoff = searchrange(minobj);
    
    %cutoff = fmincon(@(x) (falserate(x,GMMmodel)-FDR).^2,mean(markersample),[1 -1]',[prctile(markersample,99) -min(GMMmodel.mu)]);
    %cutoff = fzero(@(x) (falserate(x,GMMmodel)-FDR), mean(markersample));
    
    poscells = markersample>cutoff;
%% I'm plotting the results here; not sure how you want to incorporate this into your code
    
    %figure()
    
    histogram(markersample,'Normalization','pdf','EdgeAlpha',0.1,'FaceAlpha',0.3,'FaceColor','k')
    ylimits = ylim;
    hold on
    x = linspace(minval,max(markersample),1000);
    plot(x,pdf(GMMmodel,x'),'-k','linewidth',1)
    
    plot(x,GMMmodel.ComponentProportion(maxid)*normpdf(x,GMMmodel.mu(maxid),sqrt(GMMmodel.Sigma(maxid))),'-b','linewidth',2)
    plot(x,GMMmodel.ComponentProportion(minid)*normpdf(x,GMMmodel.mu(minid),sqrt(GMMmodel.Sigma(minid))),'-g','linewidth',2)
    
    line([cutoff cutoff], ylimits, 'Color', 'r','linewidth',2);
    xlim([min(markersample)-0.2,max(markersample)+0.2]);
    ylim(ylimits);
    ylabel('Norm. Distribution');
    
    text(cutoff+0.4,mean(ylimits)+0.1,['cutoff=' num2str(cutoff,2), char(10), '%pos=' num2str(100*sum(poscells)/length(poscells),'%2.1f'), char(10), 'FDR=' num2str(FDR+sqrt(min(objfunc)),2)],'fontsize',12)
    legend ('Ori.data','GMM fit','1st Dist.','2nd Dist.','Gate');
    %figure,plot(searchrange,log(objfunc)) %this is a diagnostic line
    
end
    
    
    
    
    