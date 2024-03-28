%% Calculate CD3+ & CD8+ in R1/R2 (for immunoscore)

tic;
for s=1:length(slideName)
    disp(strcat('Processing:',slideName{s}));
    data1 = eval(strcat('data',slideName{s}));
    data1 = removevars(data1, 'TDist');
    data1.CD3pR1 = data1.CD3ep & (data1.Region==1);
    data1.CD3pR2 = data1.CD3ep & (data1.Region==2);
    data1.CD8pR1 = data1.CD8ap & (data1.Region==1);
    data1.CD8pR2 = data1.CD8ap & (data1.Region==2);
    data1.R0 = data1.Region == 0;
    data1.R1 = data1.Region == 1;
    data1.R2 = data1.Region == 2;
    eval(strcat('data',slideName{s},'=data1;'));
    toc;
end

%% Generate immune scores;

sumAllsample.norm_CD8R1 = sumAllsample.mean_CD8pR1 ./sumAllsample.mean_R1;
sumAllsample.norm_CD8R2 = sumAllsample.mean_CD8pR2 ./sumAllsample.mean_R2;
sumAllsample.norm_CD3R1 = sumAllsample.mean_CD3pR1 ./sumAllsample.mean_R1;
sumAllsample.norm_CD3R2 = sumAllsample.mean_CD3pR2 ./sumAllsample.mean_R2;

Cutoff_CD3R1 = 0.03;
Cutoff_CD3R2 = 0.2;
Cutoff_CD8R1 = 0.025;
Cutoff_CD8R2 = 0.07;

sumAllsample.ImmunoScore = (sumAllsample.norm_CD3R1 > Cutoff_CD3R1) + (sumAllsample.norm_CD3R2 > Cutoff_CD3R2) + (sumAllsample.norm_CD8R1 > Cutoff_CD8R1) + (sumAllsample.norm_CD8R2 > Cutoff_CD8R2);
