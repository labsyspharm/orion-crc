function [idx,c,gate,pluscells] = Kmeangate(data1,k,sw1)
% Read data (numeric array) and find gate based on the distribution
% Jerry Lin 2017/03/07

%% Initialize variables.

nump = floor(length(data1)/200);

if(nump<100)
    nump=100;
end

[idx,c]=kmeans(data1,k);
[f,xi]=ksdensity(data1,'NumPoints',nump);
[max0,index0]=max(c);
[max1,index1]=max(f);

%[f,xi]=ksdensity(data1,'NumPoints',nump);

gate = min(data1(idx==index0));

lowb = prctile(data1,1);
highb = prctile(data1,99);
pluscells = data1>gate;

if(sw1==1)
    plot(xi,f);
    hold on;
    plot([gate gate],[0 max1+0.2],'--r','LineWidth',1.5);
    for i = 1:length(c)
        plot([c(i) c(i)],[0 max1+0.2],'--b','LineWidth',1.5);
        text(c(i),max1+0.1,strcat('peak=',num2str(c(i),'%0.2f')),'FontSize',10);
    end
    xlim([lowb-0.5,highb+0.5]);
    ylim([0 max1+0.2]);
    text(gate,max1*0.8, strcat('gate=',num2str(gate,'%0.2f')),'FontSize',12);
    text(gate+0.2,0.4*max1,strcat('+cells=',num2str(mean(pluscells),'%0.3f')),'FontSize',14);
end

return;

