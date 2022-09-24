function [h,p]=CycIF_pairBoxplot(datatable,channel,gate)
%% for generate boxplot with p-value & mean
%  Jerry Lin 2019/02/28


%% Initialization

data1 = log(datatable{datatable{:,gate}==0,channel}+5);
data2 = log(datatable{datatable{:,gate}==1,channel}+5);

dscatter(1+rand(length(data1),1)*0.2,data1);
hold on;
dscatter(2+rand(length(data2),1)*0.2,data2);
hold off;


[h,p]=ttest2(data1,data2);

return;


