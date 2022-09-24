function [normcount, means, sems] = normcount01(table1)
%%  return normalized cell count

temp1 = table1(table1.cycle1>500,:);
temp1 = table2array(temp1);

normcount = temp1 ./ repmat(temp1(:,1),1,size(temp1,2));
means = mean(normcount);
sems = std(normcount)/sqrt(size(temp1,2)-1);
return;


