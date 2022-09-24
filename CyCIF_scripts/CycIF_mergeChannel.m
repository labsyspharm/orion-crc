function newTable = CycIF_mergeChannel(oldtable,marker1,marker2);
%% Function to add combination of 2 channels into new column/channel
%  Jerry Lin 2017/12/05

%% Initialization

newTable = oldtable;

newTable{:,strcat(marker1,marker2)} = log(oldtable{:,marker1}).*oldtable{:,marker2};

return;
