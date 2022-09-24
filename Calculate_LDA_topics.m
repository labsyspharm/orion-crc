%% Calculate topic neighborhood (All slides);

tic;
Alltopic2topic = zeros(12,12,length(slideName));

for i = 1:length(slideName)
    disp(strcat('Processing:',slideName{i}));
    data1 = eval(strcat('data',slideName{i}));
    data2 = varfun(@mean,data1,'GroupingVariable','frame');
    temp1 = data2.Properties.VariableNames;
    temp1 = regexprep(temp1,'mean_','');
    data2.Properties.VariableNames = temp1;

    list1 = knnsearch(data2{:,{'Xt','Yt'}},data2{:,{'Xt','Yt'}},'k',10);
    list2 = data2.topics(list1);

    topic2topic = zeros(12,12);

    for k = 2:10
        temp1 = hist3(list2(:,[1,k]),{1:12 1:12});
        topic2topic = topic2topic+temp1;
    end
    Alltopic2topic(:,:,i) = topic2topic;
    toc;
end
