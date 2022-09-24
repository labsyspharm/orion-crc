function [fgate,fpos,allgate,allpos] = finegate(data1,intv,sw1,lowb,highb)
%% Read data (numeric array) and find gate based on the distribution
% Jerry Lin 2018/3/12
%
%  data1 = input data (log transformed)
%  intv  = interval (suggested 0.1-0.01)
%  sw1  = 0/1 (output switch)

%% Initialize variables.

if lowb == 0
    lowb = round(prctile(data1,2),1);
end
if highb == 0
    highb = round(prctile(data1,98),1);
end

nbins = round((highb-lowb)/intv+1,0);
allgate = NaN(nbins,1);
allpos = NaN(nbins,1);


%% Find gate
for i=1:nbins
    allgate(i) = lowb+intv*(i-1);
    allpos(i) = mean(data1>allgate(i));
end

[fpos,fidx]=knee_pt(allgate,allpos);
fgate = allgate(fidx);

if sw1>0
    plot(allgate,allpos);
    xlim([lowb highb]);
    hold on;
    plot([fgate fgate],[0 1],'--r','LineWidth',1.5);
    text(fgate+0.1,0.8, strcat('gate=',num2str(fgate,'%0.2f')),'FontSize',12);
    text(fgate+0.2,0.4, strcat('+cells=',num2str(mean(fpos),'%0.3f')),'FontSize',12);
end

return
