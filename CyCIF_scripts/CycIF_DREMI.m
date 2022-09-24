function corr1 = CycIF_DREMI(x,y,xl,yl,sw1)
%% Plot & return DREMI correlation for CycIF data
%  Jerry LIn 2017/10/29

%% Initilization

rx = round(x,1);
min1 = length(x)*0.005;

table1 = table(rx,y);

% calculation
median1 = varfun(@median,table1,'GroupingVariable','rx');
err1 = varfun(@std,table1,'GroupingVariable','rx');
median1=median1(median1.GroupCount>min1,:);
err1 = err1(err1.GroupCount>min1,:);

corr1 = corr(median1.rx,median1.median_y);
corr2 = corr(x,y);

% plot DREMI
if sw1 == 1
    figure;
    subplot(1,2,1);
    dscatter(x,y);colormap(jet);colorbar;
    xlabel(xl);
    ylabel(yl);
    title(strcat({'Single-cell r = '},num2str(corr2,'%0.2f')));
    
    subplot(1,2,2);
    scatter(median1.rx,median1.median_y,sqrt(median1.GroupCount),'k','fill');
    hold on;
    errorbar(median1.rx,median1.median_y,err1.std_y/2, 'LineStyle','none');
    hold off;
    title(strcat({'DREMI r = '},num2str(corr1,'%0.2f')));
    xlabel(xl);
    ylabel(yl);
end

return;

