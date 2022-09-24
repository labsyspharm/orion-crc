function newtable = CycIF_removebackground(oldtable,chs)
%% Function to process CycIF table: remove high background cells/rows in the data table
%  Jerry Lin 2018/03/16
%
%  Usage:  newtable = CycIF_removezero(oldtable,chs);
%          
%           oldtable: original CycIF data table
%           newtable: cleanup  CycIF data table
%           chs: cell array for background channels(names)  

%%  Initialization

arrays = zeros(length(oldtable.AREA),length(chs));


%%  Check each background channel

for i=1:length(chs)
    [arrays(:,i),~,~,~,~]=findgate3(log(oldtable{:,chs{i}}),0,0.05,0);
end

flag = prod(arrays,2);
newtable = oldtable(flag==0,:);

return;
