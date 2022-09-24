%% Resample all slides using datalist/slidelist
%  Jerry Lin 2019/07/10


%% Initialization

allsample_re = table;
datalist = slideName;
samplesize = input('Please input sample size:');
repflag = input('Replacement sampling (1:yes, 0:no):');
repflag = logical(repflag);
outflag = input('Output CSV files (y/n)?','s');

%% looping all slides

for i = 1:length(datalist)
    name1 = datalist{i};
    disp(strcat('Processing:',name1));
    eval(strcat('data1=data',name1,';'));
    sample1 = datasample(data1,samplesize,'replace',repflag);
    if ismember(outflag,{'y','Y','true','True'})
        filename = strcat('sample',name1,'.csv');
        writetable(sample1,filename);
    end
    eval(strcat('sample',slideName{i},'=sample1;'));
    sample1.slideName = repmat({name1},samplesize,1);
    if isempty(allsample_re)
        allsample_re = sample1;
    else
        allsample_re = vertcat(allsample_re,sample1);
    end
end

clear data1 sample1;
