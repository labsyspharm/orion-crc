%% Generate all well Mean & Median from lookup table
% for Mario CycIF data
% 20160409 Jerry

%% Initialize variables

Allmean = zeros(60,30);
Allmedian = zeros(60,30);

for i = 1:60
    Allmean(i,:) = mean(Lookup{i,4});
    Allmedian(i,:) = median(Lookup{i,4});
end
