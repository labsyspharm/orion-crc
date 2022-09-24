function data2 = CycIF_gateall(data1,gatetype)
%% gating all channels and return a new table;
% gatetype : 1 = findgate3; 2 = kmeangate
% Jerry Lin 2017/09/01

%% Initialization

names = data1.Properties.VariableNames;

idx1 = find(ismember(names,'A488'));
idx2 = find(ismember(names,'AREA'))-1;
data2 = data1;

for i=idx1:idx2
    marker1 = names(i);
    gate1 = strcat(names(i),'p');
    disp(strcat('Now processing:',marker1));
    if(gatetype ==1)
       [data2{:,gate1},~,~,~,~]=findgate3(log(data2{:,marker1}),0,0.05,0);
    else
        [data2{:,gate1},~,~,~]=Kmeangate(log(data2{:,marker1}),2,0);
    end
end

return;
