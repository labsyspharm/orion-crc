

allsample = table;
samplesize = 5000;
sw1 = true;
s100gate = 9;


for i =1:length(slideName)
        name1 = strcat('data',slideName{i});
        disp(strcat('Select Columns & resampling:',name1));
        data1 = eval(name1);
        %data1 = data1(:,test3);
        
        data1.S100p = data1.S100 > exp(S100gate);
        knn20 = fitcknn(data1{:,{'Xt','Yt'}},data1.S100p,'Ne
        eval(strcat(name1,'=data1;'));
        
        sample1 = datasample(data1,samplesize);
        
        if(sw1)
            filename = strcat('sample',slideName{i},'.csv');
            writetable(sample1,filename);
        end
        
        eval(strcat('sample',slideName{i},'=sample1;'));
        sample1.slidename = repmat(slideName(i),length(sample1.X),1);
        
        if(isempty(allsample))
            allsample = sample1;
        else
            allsample = vertcat(allsample,sample1);
        end      
end