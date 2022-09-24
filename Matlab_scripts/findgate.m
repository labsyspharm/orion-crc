function [pluscells, gate, peak] = findgate2(data1,sw1)
% Read data (numeric array) and find gate based on the distribution
% Jerry Lin 2017/03/07

%% Initialize variables.
bins = floor(length(data1)/100);
[counts,centers] = hist(data1,bins);

[max1,index1]=max(counts(5:end));

counts2 = counts(5:index1);
counts2 = fliplr(counts2);
[min1,index2]=min(counts2);

peak = centers(index1);
lowb = centers(index1-index2);
mid1 = floor((index1+bins)/2);
if((index1+index2)<mid1)
    gate = centers(index1+index2);
else
    gate = centers(mid1);
end
pluscells = data1>gate;

if(sw1==1)
    figure,hist(data1,bins);
    hold on;
    plot([gate gate],[0 max1]);
    plot([peak peak],[0 max1]);
    xlim([lowb-1,gate+3]);
    title(strcat('peak = ',num2str(peak),' gate = ',num2str(gate)));
end

return;

