%% Calculate positive cells for all slides
%  Jerry Lin 2017/03/07
%  Need datalabels (cell array)



%%Initialiation
datatable = cell2table(datalabels);

datatable.Properties.VariableNames ={'name'};

datano = length(datalabels);

%% CD8/PD1/CD4 positive cells  --> using findplus function
CD8plus = zeros(datano,1);
CD4plus = zeros(datano,1);
PD1plus = zeros(datano,1);
FOXP3plus = zeros(datano,1);
CD11bplus = zeros(datano,1);


%%FOXP3/CD3/PDL1/CD45/Ki67/CD20 --> using findgate function
PDL1plus = zeros(datano,1);
CD45plus = zeros(datano,1);
Ki67plus = zeros(datano,1);
CD20plus = zeros(datano,1);
%PCNAplus = zeros(datano,1);

for i=1:datano
    eval(strcat('temp1 = DATA',datalabels{i},';'));
    [pluscells, CD8plus(i,1),predict1] = findplus(log(temp1.CD8+5),log(temp1.A488+5),2.5,0,2);
    [pluscells, PD1plus(i,1),predict1] = findplus(log(temp1.PD1+5),log(temp1.A488+5),2.5,0,2);
    [pluscells, CD4plus(i,1),predict1] = findplus(log(temp1.CD4+5),log(temp1.A555+5),2.5,0,2);
    [pluscells, FOXP3plus(i,1),predict1] = findplus(log(temp1.FOXP3+5),log(temp1.A647+5),2.5,0,2);
    [pluscells, CD11bplus(i,1),predict1] = findplus(log(temp1.CD11b+5),log(temp1.A488+5),2.5,0,2);
  
    %[pluscells, gate, peak] = findgate(log(temp1.FOXP3+5),0);
    %FOXP3plus(i,1) = mean(pluscells);
    
    %[pluscells, gate, peak] = findgate(log(temp1.PCNA+5),0);
    %PCNAplus(i,1) = mean(pluscells);

    [pluscells, gate, peak] = findgate(log(temp1.PDL1+5),0);
    PDL1plus(i,1) = mean(pluscells);

    [pluscells, gate, peak] = findgate(log(temp1.CD45+5),0);
    CD45plus(i,1) = mean(pluscells);

    [pluscells, gate, peak] = findgate(log(temp1.Ki67+5),0);
    Ki67plus(i,1) = mean(pluscells);

    [pluscells, gate, peak] = findgate(log(temp1.CD20+5),0);
    CD20plus(i,1) = mean(pluscells);

end

datatable.CD8 = CD8plus;
datatable.PD1 = PD1plus;
datatable.CD4 = CD4plus;
datatable.FOXP3 = FOXP3plus;
datatable.CD11b = CD11bplus
datatable.PDL1 = PDL1plus;
datatable.CD45 = CD45plus;
datatable.Ki67 = Ki67plus;
datatable.CD20 = CD20plus;

