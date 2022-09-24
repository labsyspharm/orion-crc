function table1 = CycIF_importPIPcsv(filename,scalefactor)
%% function to import csv from pipeline 
%  Jerry Lin 2019/12/06
%
%  filename:  csv file name (string)
%  scalefactor:  0.65 for 20x 2x2 binning 
%

%% Initialization

imagename = strrep(filename,'.csv','');


%% change labels
test1 = readtable(filename);
test2 = test1(:,3:end);
label1 = test2.Properties.VariableNames;
label1 = label1';
label2 = strrep(label1,strcat('Cell_',imagename),'');
label2 = strrep(label2,'X_position','Xt');
label2 = strrep(label2,'Y_position','Yt');
label2 = strrep(label2,'Area','AREA');
label2{2} = 'A488';
label2{3} = 'A555';
label2{4} = 'A647';
test2.Properties.VariableNames = label2;


%%  Rescaling
index1=find(strcmp(label2,'AREA'))-1;
test2{:,1:index1}=exp(test2{:,1:index1});
test2.Xt = test2.Xt * scalefactor;
test2.Yt = test2.Yt * scalefactor;
test2.X = repmat(1280 * scalefactor,size(test2,1),1);
test2.Y = repmat(1024 * scalefactor,size(test2,1),1);

%% remove zeros
flag1 = prod(test2{:,1:index1},2)>0;
table1 = test2(flag1,:);

return;
