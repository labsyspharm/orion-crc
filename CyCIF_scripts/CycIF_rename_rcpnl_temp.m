%% CycIF rename rcpnl files
%% Jerry Lin 2017/03/05

mypath= uigetdir;

cd(mypath);
list1 = dir('*.*');
[~,index] = sortrows({list1.datenum}.'); 
list1 = list1(index); 
clear index;
table1 = struct2table(list1);

temp1 = table1.name;

for i=1:size(table1,1)
    temp1(i) = {strcat('Cycle',num2str(i,'%02d'),'.rcpnl')};
end

table1.newname = temp1;
writetable(table1,'allnames04.txt');

for i =1:size(table1,1)
    %movefile(table1.name{i},table1.newname{i});
    command1 = strcat('rename',{' '},table1.name{i},{' '},table1.newname{i});
    dos(command1{1},'-echo');
    disp(command1);
    %disp(table1.newname{i}); 
end
 