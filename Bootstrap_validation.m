%% Bootstrap sampling validation 

maxN = 500;
sz = 30;
testR = zeros(size(sumAllsample,1),2);
testHR = zeros(size(sumAllsample,1),2);

for n= 1:maxN
    sum2 = datasample(sumAllsample,sz,'replace',false);

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

testHR = testHR(~isinf(mean(testHR,2)),:);
figure,myviolinplot2(testHR);
ylim([0 30]);
set(gca,'xticklabels',{'IFM2','IFM1'});
title('Bootstrap Sampling');
ylabel('Hazard ratio');

figure,myviolinplot2(fliplr(1./testHR));
%ylim([0 30]);
set(gca,'xticklabels',{'IFM1','IFM2'});
title('Bootstrap Sampling');
ylabel('Hazard ratio');
