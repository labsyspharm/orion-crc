function [pluscells, gate, peak,lowb,highb] = findgate3(data1,sw1,bound,mgate)
% Read data (numeric array) and find gate based on the distribution
% Jerry Lin 2017/03/07
%
% Usage:    data1-->data array
%           sw1 --> plot switch (0:off, 1:on);
%           bound --> confident interval (default 0.05)
%           mgate --> default gate (0 for automatic)
%
% Ouptut:   pluscells --> postive cells (logical array)
%           gate --> gate value (double)            
%           peak --> peak value (double)
%           lowb --> low bound of the first peak (double)
%           highb --> high bound of the first peak (double)
%
% example:  [pluscells2, gate, ~,~,~]=findgate3(list1,1,0.05,0);
%
%% Initialize variables.

nump = floor(length(data1)/200);

if(nump<100)
    nump=100;
end

[f,xi]=ksdensity(data1,'NumPoints',nump);

[max1,index1]=max(f);

counts2 = f(1:index1);
counts2 = fliplr(counts2);

%[min1,index2]=min(counts2);
index2=1;
while (counts2(index2)>bound*max1 && index2<length(counts2))
    index2=index2+1;
end
index3=index1;
while (f(index3)>bound*max1 && index3<length(f))
    index3=index3+1;
end


peak = xi(index1);

if index1-index2 >1
    lowb = xi(index1-index2);
else
    lowb = xi(1);
end

highb = xi(index3);

if(highb < prctile(data1,99))
    highb = prctile(data1,99);
end

mid1 = floor((index1+nump)/2);
if(mgate>0)
    gate = mgate;
else
    if((index1+index2)<mid1)
        gate = xi(index1+index2);
    else
        gate = xi(mid1);
    end
end
pluscells = data1>gate;

if(sw1==1)
    plot(xi,f);
    hold on;
    plot([gate gate],[0 max1+0.2],'--r','LineWidth',1.5);
    plot([peak peak],[0 max1+0.2],'--b','LineWidth',1.5);
    xlim([lowb-0.5,highb+1]);
    ylim([0 max1+0.2]);
    %title(strcat('peak = ',num2str(peak),' gate = ',num2str(gate),' positive =',num2str(mean(pluscells))));
    text(peak,max1+0.1,strcat('peak=',num2str(peak,'%0.2f')),'FontSize',12);
    text(gate,max1/2, strcat('gate=',num2str(gate,'%0.2f')),'FontSize',12);
    text(gate+0.2,0.2*max1,strcat('+cells=',num2str(mean(pluscells),'%0.3f')),'FontSize',12);
end

return;










