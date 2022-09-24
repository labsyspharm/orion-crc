%% CycIF grouping all
%  Jerry Lin 2019/09/06
%
%  Generate catetorical groups using gated markers
% 


%% Initialization

groupmarkers = {'S100pNGFRp','CD8ap','CD4pFOXP3n','CD4pFOXP3p','SMAp'};


%% Grouping all slides

for i =1:length(slideName)
    disp(strcat('Processing:',slideName{i}));
    data1 = eval(strcat('data',slideName{i}));
    data1.cluster2 = ones(size(data1,1),1);
    for j=1:length(groupmarkers)
        flag = data1{:,groupmarkers{j}}==1;
        data1.cluster2(flag)=j+1;
    end
    eval(strcat('data',slideName{i},'=data1;'));
end



