
function [rhoA,pvalueA]= allcorr(data1,corrtype)
%% Calculate correlation column-by-column
%   data1 = data array 
%   corrtype = method used ('Pearson','Spearman','Kendall')


size1 = size(data1,2);
rhoA = repmat([1],size1,size1);
pvauleA = repmat([0],size1,size1);

for i = 1:size1
   for j = i:size1
       [rhoA(i,j),pvalueA(i,j)]= corr(data1(:,i),data1(:,j),'type',corrtype);
       rhoA(j,i)=rhoA(i,j);
       pvauleA(j,i)=pvalueA(i,j);
   end
end


return;
