%% CycIF grouping all
%  Jerry Lin 2019/09/06
%
%  Generate catetorical groups using gated markers
% 


%% Iniitilization

groupmarkers = {'PR_488p','ER_PEp','HER2_647p'};
tlabels = {'TN','PR+','ER+','PR+ER+','HER2+','HER2+PR+','HER2+ER+','HER2+ER+PR+'};

%% Grouping all slides

for i =1:length(slideName)
    data1 = eval(strcat('data',slideName{i}));
    
    test1 = data1{:,groupmarkers};
    test1 = int16(test1);
    data1.group = bi2de(test1)+1;
    eval(strcat('data',slideName{i},'=data1;'));
end

%% regrouping


for i = 1:length(slideName)
    disp(strcat('Processing:',slideName{i}));
    data1 = eval(strcat('data',slideName{i}));
    data2 = zeros(size(data1,1),2^length(groupmarkers));
    for j = 1:2^length(groupmarkers)-1
        data2(:,j+1) = data1.group==j+1;
    end
    data2 = array2table(data2,'VariableNames',matlab.lang.makeValidName(tlabels));
    data1 = horzcat(data1,data2);
    eval(strcat('data',slideName{i},'=data1;'));
end

clear data1 data2;

%% summary

% sumHTMA240 = varfun(@mean,dataHTMA240,'GroupingVariable','ROI');
% sumHTMA226 = varfun(@mean,dataHTMA226,'GroupingVariable','ROI');
% sumHTMA227 = varfun(@mean,dataHTMA227,'GroupingVariable','ROI');
% 
% sumHTMA240 = sumHTMA240(sumHTMA240.GroupCount>100,:);
% sumHTMA226 = sumHTMA226(sumHTMA226.GroupCount>100,:);
% sumHTMA227 = sumHTMA227(sumHTMA227.GroupCount>100,:);

