%% CycIF_tumorknn_allslide
%  Jerry Lin 2021/11/16
%
%  Processing KNN model to all slides/samples
%  Resampling & generate allsample
%  Require "slideName" cell array
%  Add distance 

%% Initialization

TumorMarker = input('Please input tumor marker (CKp):','s'); 
minDist = input('Please input minDist (Default = 100):');
K = input('Please input k (Default = 25):');
marker1 = input('Please input variable name (Region):','s');

%K = 25;
%minDist = 100;

samplesize = input('Please input sample size (0 for nosampling):'); %5000;
if samplesize>0
    allsample = table;
end
%% Processing all slides
for i =1:length(slideName)
        name1 = strcat('data',slideName{i});
        disp(strcat('Processing:',name1));

        data1 = eval(name1);
        tic;
        % Processing data 
        
%         knnMdl = fitcknn(data1{:,{'Xt','Yt'}},data1{:,TumorMarker},'NumNeighbors',K);
%         data1.TMKNN = predict(knnMdl,data1{:,{'Xt','Yt'}});
        list1 = knnsearch(data1{:,{'Xt','Yt'}},data1{:,{'Xt','Yt'}},'k',K);
        list1 = data1{:,TumorMarker}(list1);
        list1 = mean(list1,2);
        data1.TMKNN = list1 > 0.5;
        
        disp(strcat('TumorMarker knn cells =',num2str(mean(data1.TMKNN))));
        if mean(data1.TMKNN)>0
            data1.TDist = repmat(-1,length(data1{:,TumorMarker}),1);
            [Idx,D]=knnsearch(data1{data1.TMKNN==1,{'Xt','Yt'}},data1{data1.TMKNN==0,{'Xt','Yt'}},'K',1);
            data1{data1.TMKNN==0,'TDist'} = D;
            data1.TumorBoarder = data1.TDist > 0 & data1.TDist < minDist;
            data1{:,marker1} = zeros(length(data1{:,TumorMarker}),1);
            data1{data1.TMKNN==1,marker1}=1;
            data1{data1.TumorBoarder==1,marker1}=2;
            tabulate(data1{:,marker1});
        else
            data1.TDist = repmat(-1,length(data1{:,TumorMarker}),1);
            data1.TumorBoarder = zeros(length(data1{:,TumorMarker}),1);
            data1.Region = zeros(length(data1{:,TumorMarker}),1);
            tabulate(data1{:,marker1});
        end

        data1(:,'TumorBoarder') = [];
        %data1(:,name1) = [];
        data1(:,'TMKNN') = [];
        %data1(:,'KD') = [];
        eval(strcat(name1,'=data1;'));

        % Resampling
        if samplesize > 0
            sample1 = datasample(data1,samplesize);
            eval(strcat('sample',slideName{i},'=sample1;'));
            sample1.slidename = repmat(slideName(i),length(sample1.X),1);
            if(isempty(allsample))
                allsample = sample1;
            else
                allsample = vertcat(allsample,sample1);
            end
        end
        toc;
end


