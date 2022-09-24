%% Correlation between marker+ with PFS days (FigS4)

figure('units','normalized','outerposition',[0.5 0 0.5 1]);

for i = 1:16
    subplot(4,4,i);
    marker1 = strcat('mean_',labelp{i});
    list1 = sumAllsample{:,marker1};
    list2 = sumAllsample.PFSDays;
    corr1 = corr(list1,list2);
    if(abs(corr1)>0.5)
        color1 = 'r';
    else
        color1 = 'b';
    end
    scatter(list1,list2,20,'k','fill');
    lsline;
    xlabel(labelp2{i},'Color',color1,'Interpreter','none');
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    ylabel('PFS days');
    title(num2str(corr(list1,list2),'%0.2f'),'Color',color1);
    %set(gca,'ticklabelinterpreter','none');
end


%% Correlation between Topics with PFS days (FigS5)

figure('units','normalized','outerposition',[0.4 0.3 0.6 0.7]);

for i = 1:12
    subplot(3,4,i);
    marker1 = strcat('mean_topic',num2str(i));
    list1 = sumAllsample{:,marker1};
    list2 = sumAllsample.PFSDays;
    corr1 = corr(list1,list2);
    if(abs(corr1)>0.5)
        color1 = 'r';
    else
        color1 = 'b';
    end
    scatter(list1,list2,20,'k','fill');
    lsline;
    xlabel(strcat('Topic',num2str(i)),'Color',color1);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    ylabel('PFS days');
    title(num2str(corr1,'%0.2f'),'Color',color1);
end
