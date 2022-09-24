%% Triplet remove zeros & background (A488 & A555)
%% Jerry LIn 2017/08/10

% require slideName variable from CycIF_import

%% Initialization

samplesize = 3000;


%% Remove zero from all data points

for i =1:length(slideName)
        name1 = strcat('data',slideName{i});
        disp(strcat('Removing zeros',{' '},name1));
        data1 = eval(name1);
        %[A488p,~,~,~,~]=findgate3(log(data1.A488+5),0,0.05,0);
        %[A555p,~,~,~,~]=findgate3(log(data1.A555+5),0,0.05,0);
        %data1.A555p = A555p;
        %data1.A488p = A488p;
        names = data1.Properties.VariableNames;
        idx = find(ismember(names,'AREA'))-1;
        data2 = data1{:,1:idx};
        flag = prod(data2,2);
        data3 = data1(flag>0,:);
        eval(strcat(name1,'=data3;'));
end

clear data1 data2 data3;

%% Remove background from all data points

for i =1:length(slideName)
        name1 = strcat('data',slideName{i});
        disp(strcat('Removing backgrounds',{' '},name1));
        data1 = eval(name1);
        [A488p,~,~,~,~]=findgate3(log(data1.FITC_1+5),0,0.05,0);
        [A555p,~,~,~,~]=findgate3(log(data1.Cy3_1+5),0,0.05,0);
        data1.A555p = A555p;
        data1.A488p = A488p;
        
        data2 = data1(data1.A488p==0,:);
        data2 = data2(data2.A555p==0,:);
        %disp(strcat('Processsing',{' '},name1));
        eval(strcat(name1,'=data2;'));
        sample1 = datasample(data2,samplesize);
        eval(strcat('sample',slideName{i},'=sample1;'));
end

clear A555p A488p data1 data2 sample1;

%% X-axis normalization (flatten)

allsample = table;

for i =1:length(slideName)
        name1 = strcat('data',slideName{i});
        disp(strcat('Flatfield correction',{' '},name1));
        data1 = eval(name1);
        
        data2 = CycIF_normdata(data1);
        
        eval(strcat(name1,'=data2;'));
        sample1 = datasample(data2,samplesize);
        eval(strcat('sample',slideName{i},'=sample1;'));
                
        sample1.slidename = repmat(slideName(i),length(sample1.X),1);
        if(isempty(allsample))
            allsample = sample1;
        else
            allsample = vertcat(allsample,sample1);
        end

end

clear data1 data2 sample1;



        