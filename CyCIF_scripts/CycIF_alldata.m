%% CycIF_alldata
%   Generate alldata from all data tables
%   Require slideName
%   Jerry Lin 2020/04/14


%% Initialization

alldata = table;

i = 1;
data1 = eval(strcat('data',slideName{i}));
data1.slideName = repmat(slideName(i),size(data1,1),1);

alldata = data1;

for i=2:length(slideName)
    data1 = eval(strcat('data',slideName{i}));
    data1.slideName = repmat(slideName(i),size(data1,1),1);

    alldata = vertcat(alldata,data1);
end
clear i data1;
