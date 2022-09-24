%% CycIF_tumorknn_TMA
%  Jerry Lin 2022/02/14
%
%  Processing KNN model to all TMA cores
%  Resampling & generate allsample
%  Require ROI column
%

%% Initialization

dataname = input('Please input the data name (dataXXXX):','s');
TumorMarker = input('Please input tumor marker (CKp):','s'); 
minDist = input('Please input minDist (Default = 100):');
K = input('Please input k (Default = 25):');
marker1 = input('Please input variable name (Region):','s');

%K = 25;
%minDist = 100;
data0 = eval(dataname);
data0{:,marker1}=zeros(size(data0,1),1);
data0.TDist = zeros(size(data0,1),1);


%% Processing all core
for i =1:max(data0.ROI)
        disp(strcat('Processing core:',num2str(i)));
        flag1 = data0.ROI ==i;
        data1 = data0(flag1,:);
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
            data1{:,marker1} = zeros(length(data1{:,TumorMarker}),1);
            tabulate(data1{:,marker1});
        end

        data1(:,'TumorBoarder') = [];
        %data1(:,name1) = [];
        data1(:,'TMKNN') = [];

        toc;
        data0{flag1,marker1}=data1{:,marker1};
        data0{flag1,'TDist'}=data1.TDist;
end

eval(strcat(dataname,'=data0;'));

