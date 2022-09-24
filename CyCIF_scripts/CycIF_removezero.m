function newtable = CycIF_removezero(oldtable)
%% Function to process CycIF table: remove all zero-containing rows in the data table
%  Jerry Lin 2018/03/16
%
%  Usage:  newtable = CycIF_removezero(oldtable);
%          
%           oldtable: original CycIF data table
%           newtable: cleanup  CycIF data table

%%  Removing zeros

names = oldtable.Properties.VariableNames;
idx = find(ismember(names,'AREA'))-1;
if(isempty(idx))
    idx = find(ismember(names,'Area'))-1;
end
temp1 = oldtable{:,1:idx};
zeroflag = prod(temp1,2);
newtable = oldtable(zeroflag>0,:);

return;

