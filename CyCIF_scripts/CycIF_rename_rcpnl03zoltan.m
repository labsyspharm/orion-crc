%% CycIF rename rcpnl files
%% Jerry Lin 2017/03/05

mypath= uigetdir('H:\Imagetemp2\SHOM-2017AUG');

cd(mypath);
list1 = dir('*.rcpnl');
[~,index] = sortrows({list1.datenum}.'); 
list1 = list1(index); 
clear index;
table1 = struct2table(list1);

temp1 = table1.name;

for i=1:size(table1,1)
    temp1(i) = {strcat('Cycle',num2str(i),'.rcpnl')};
end
     
table1.newname = temp1;
writetable(table1,'allnamesZoltan.txt');

%%for Zoltan re-rename
for i =1:size(table1,1)
    %movefile(table1.name{i},table1.newname{i});
    command1 = strcat('rename',{' '},table1.name{i},{' temp'},table1.name{i});
    dos(command1{1},'-echo');
    disp(command1);
    %disp(table1.newname{i}); 
end

for i =1:size(table1,1)
    %movefile(table1.name{i},table1.newname{i});
    command1 = strcat('rename',{' temp'},table1.name{i},{' '},table1.newname{i});
    dos(command1{1},'-echo');
    disp(command1);
    %disp(table1.newname{i}); 
end
