datano = length(datalabels);

%filetype = '.csv';

for i=1:datano
    display(strcat('temp1 = datasample(DATA',datalabels{i},',10000);'));
    %eval(strcat('temp1 = datasample(DATA',datalabels{i},',10000);'));
    
    display(strcat('sample',datalabels{i},'=temp1(:,labels_shared);'));
    %eval(strcat('sample',datalabels{i},'=temp1(:,labels_shared);'));
    
    display(strcat('writetable(sample',datalabels{i},',''',datalabels{i},'.csv'');'));
    %eval(strcat('writetable(sample',datalabels{i},',',test4{i},');'));
end
