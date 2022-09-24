%% CycIF normalization of all slides
%  Jerry Lin 2019/07/18


%% Initilization

highbound = 30000;
highprc = 99;

lowfloor = 5000;
lowprc = 1;

header = 'norm';
normcolumns = 1:45;

%% processing through all slides

for i=1:length(slideName)
    disp(strcat('Processing:',slideName{i}));
    data1 = eval(strcat('data',slideName{i}));
    
    for j=normcolumns
        data1{:,j}=data1{:,j}*highbound/prctile(data1{:,j},highprc);
        data1{:,j}=data1{:,j}-prctile(data1{:,j},lowprc)+lowfloor;
        data1 = data1(data1{:,j}>4000,:);
    end
    eval(strcat(header,slideName{i},'=data1;'));
end



%% Resampling 

normsample = table;
datalist = slideName;
samplesize = 10000;

for i = 1:length(datalist)
    name1 = datalist{i};
    disp(strcat('Processing:',name1));
    eval(strcat('data1=',header,name1,';'));
    sample1 = datasample(data1,samplesize);
    sample1.slidename = repmat({name1},samplesize,1);
    if isempty(normsample)
        normsample = sample1;
    else
        normsample = vertcat(normsample,sample1);
    end
end

clear data1 sample1;
