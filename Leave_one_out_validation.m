%% leave one out validation 

testR = zeros(size(sumAllsample,1),2);
testHR = zeros(size(sumAllsample,1),2);

for n= 1:size(sumAllsample,1)
    sum2 = sumAllsample(~ismember(1:size(sumAllsample,1),n),:);

    %----Test set----
    i = 3;
    markers = allmarkers(arrayIs(i,:));


    tempScore = zeros(size(sum2,1),1);
    for j = 1:length(markers)
        list1 = sum2{:,markers{j}};
        cutoff1 = median(list1);
        tempScore = tempScore + (list1 > cutoff1);
    end
    
    sum2.flag1 = repmat({'Low Score'},size(sum2,1),1);
    sum2.flag1(tempScore>2)={'High Score'};
    testR(n,1) = corr(tempScore,sum2.PFSDays,'Type','Spearman');
    [~, ~, stats]=MatSurv(sum2.PFSDays,sum2.Recurrence,sum2.flag1,'NoPlot',true,'NoRiskTable',true);
    testHR(n,1) = stats.HR_logrank_Inv;
    
    %----Target set (original IS)----
    i = find(arrayIs(:,1) & arrayIs(:,2) & arrayIs(:,14) & arrayIs(:,15));
    markers = allmarkers(arrayIs(i,:));


    tempScore = zeros(size(sum2,1),1);
    for j = 1:length(markers)
        list1 = sum2{:,markers{j}};
        cutoff1 = median(list1);
        tempScore = tempScore + (list1 > cutoff1);
    end
    
    sum2.flag1 = repmat({'Low Score'},size(sum2,1),1);
    sum2.flag1(tempScore>2)={'High Score'};
    testR(n,2) = corr(tempScore,sum2.PFSDays,'Type','Spearman');
    [~, ~, stats]=MatSurv(sum2.PFSDays,sum2.Recurrence,sum2.flag1,'NoPlot',true,'NoRiskTable',true);
    testHR(n,2) = stats.HR_logrank_Inv;

end
%% plot testHR (for leave-one-out validatoin)

figure;
hold on;
for i = 1:size(testHR,1)
    plot([1,2],[testHR(i,1),testHR(i,2)],'k-o','LineWidth',0.5);
end

myboxplot2(testHR);
set(gca,'xticklabels',{'IFM2','IFM1'});
ylim([0 30]);
hold on;
title('Leave-one-out Cross-Validation');
ylabel('Hazard ratio');
