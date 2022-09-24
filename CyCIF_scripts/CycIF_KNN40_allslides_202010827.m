%% CyCIF knnsearch 40 nearest 
%  Need label1 & slideName
%  Jerry Lin 2021/08/27


f = waitbar(0,'','Name','Calculating KNN40...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

tic
for i = 1:length(slideName)
    waitbar(i/length(slideName),f,slideName{i})

    disp(strcat('Processing:',slideName{i}));
    data1 = eval(strcat('data',slideName{i}));
    KNN40 = knnsearch(log(data1{:,label1}),log(data1{:,label1}),'K',40);
    eval(strcat('knn40',slideName{i},'=KNN40;'));
    toc;
    if getappdata(f,'canceling')
        break
    end
end

clear KNN40 data1;

    
