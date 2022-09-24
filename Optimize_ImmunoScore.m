%% Extensive test for all combinations

k = 4;
list1 = 1:length(allmarkers);
test1 = nchoosek(list1,k);

maxR = 0;
maxI = 0;
f = waitbar(0, 'Starting');
arrayR = zeros(size(test1,1),1);
arrayI = false(size(test1,1),length(allmarkers));

n = size(test1,1);
for i = 1:size(test1,1)
    markers = allmarkers(test1(i,:));

    tempScore = zeros(size(sumAllsample,1),1);
    for j = 1:length(markers)
        list1 = sumAllsample{:,markers{j}};
        cutoff1 = median(list1);
        tempScore = tempScore + (list1 > cutoff1);
    end    
    r = corr(tempScore,sumAllsample.PFSDays,'Type','Spearman');
    if r > maxR
        maxR = r;
        maxI = i;
    end
    arrayR(i) = r;
    arrayI(i,test1(i,:)) = true;
    
    waitbar(i/n, f, sprintf('Progress: %d %%', floor(i/n*100)));
end
close(f);

%% Check result
%i = 3;

%i = find(arrayIs(:,1) & arrayIs(:,2) & arrayIs(:,14) & arrayIs(:,15));
%markers = allmarkers(arrayIs(i,:))

%i = 3060;
i = 3;
markers = allmarkers(arrayIs(i,:))

tempScore = zeros(size(sumAllsample,1),1);
for j = 1:length(markers)
    list1 = sumAllsample{:,markers{j}};
    cutoff1 = median(list1);
    tempScore = tempScore + (list1 > cutoff1);
end


sum2 = sumAllsample;
sum2.flag1 = repmat({'Low Score'},size(sum2,1),1);
sum2.flag1(tempScore>2)={'High Score'};
MatSurv(sum2.PFSDays,sum2.Recurrence,sum2.flag1);

figure('units','normalized','outerposition',[0 0.05 0.5 0.95]);
subplot(2,1,1);
boxplot(sumAllsample.PFSDays,tempScore);
hold on;
scatter(tempScore+1,sumAllsample.PFSDays,75,'b','fill');
ylabel('PFS days');xlabel('Score');
%lsline;
hold off;

subplot(2,1,2);
myboxplot2(sum2.PFSDays,sum2.flag1);
hold on;
scatter(grp2idx(sum2.flag1),sumAllsample.PFSDays,50,'b','fill');
ylabel('PFS days');
%lsline;
hold off;


%% heatmap of all combinations

figure('units','normalized','outerposition',[0 0 1 1]);

[arrayRs, index]=sortrows(arrayR,'descend');
arrayIs = arrayI(index,:);
i = find(arrayIs(:,1) & arrayIs(:,2) & arrayIs(:,10) & arrayIs(:,11));
subplot(4,1,1);
bar(arrayRs);
ylims = ylim;
line([i i],ylims,'Color','r','LineWidth',2);
ylim(ylims);
set(gca,'xtick',[]);

subplot(4,1,2:4)
imagesc(arrayIs');
colormap(cool);
ylabels = regexprep(allmarkers,'norm_','');
ylabels = regexprep(ylabels,'R1','');
ylabels = regexprep(ylabels,'R2','');
xlims = xlim;
ylims = ylim;
line(xlims,[mean(ylims),mean(ylims)],'Color','k','LineWidth',2);

set(gca,'ytick',1:length(allmarkers));
set(gca,'yticklabels',ylabels);
set(gca,'ticklabelinterpreter','none');
set(gca,'xtick',[]);
xlabel('All combinations');
