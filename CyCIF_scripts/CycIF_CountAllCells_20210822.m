%% CycIF_CountAllCells

for i = 1:length(slideName)
data1 = eval(strcat('data',slideName{i}));
if exist('total1')
total1 = total1 + size(data1,1);
else
total1 = size(data1,1);
end
end