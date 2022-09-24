function JD = jaccardindex(a,b)
%% calculate jaccard index
% JD = 1 - sum(a&b)/sum(a|b)

JD = sum(a & b) / sum(a|b);
return;
