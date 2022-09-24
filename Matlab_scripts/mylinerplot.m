function h1=mylinerplot(x1,y)

    %x1=x1/100;
    %y=y/100; 
    X = [ones(size(x1)) x1];
    [b,bint] = regress(y,X); 
    xval = min(x1)-0.5:0.5:max(x1)+0.5;
    yhat = b(1)+b(2)*xval;
    ylow = bint(1,1)+bint(2,1)*xval;ylow = ylow * 1.15;
    yupp = bint(1,2)+bint(2,2)*xval;yupp = yupp * 0.85;
    h1=plot(x1,y,'ks', 'LineWidth', 3, 'MarkerSize', 2);
    xlims = xlim;
    ylims = ylim;
    % p5.Color(4) = 0.5;
    hold on;
    p6=plot(xval,yhat,'k','linewidth',3);
    p6.Color(4) = 0.5;
    %axis([0.04 0.3 0.03 .35])
    fontSize = 12;
    hold on
    patch([xval fliplr(xval)], [ylow fliplr(yupp)], 'k','EdgeColor','white')
    alpha(0.3)
    leg=legend('Observed values','Regression line','95% C.I');
    set(leg,'location','best')
    xlabel('Observed', 'FontSize', fontSize);
    ylabel('Predicted', 'FontSize', fontSize);
    %xlim(xlims);
    %ylim(ylims);
    set(gcf,'color','white')
    bias=sum(y-x1)/length(y);
    tbl = table(y , x1);
    mdl = fitlm(tbl,'linear');
    str=[    'N = ',sprintf('%d',mdl.NumObservations),...
    ', Bias = ',sprintf('%.3f',bias),...    
    ' m^3/m^3, R^2 = ',sprintf('%.2f',mdl.Rsquared.Ordinary),...
    %'y = ',sprintf('%.2f',table2array(mdl.Coefficients(2,1))),'x + ',sprintf('%.2f',table2array(mdl.Coefficients(1,1)))
    ]
    annotation('textbox',[.15 0.9 0 0],'string',str,'FitBoxToText','on','EdgeColor','black')  
return;
    