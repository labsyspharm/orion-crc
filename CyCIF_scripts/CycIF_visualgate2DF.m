function [pluscells,newdatatable,gate1,gate2]=CycIF_visualgate2DF(datatable,ch1,ch2,mgate1,mgate2,outsw)
%% For visualization & gating CycIF datatable, require CycIF_tumorview
%  Jerry Lin 2018/03/08
%
%  datatable : CycIF table format (need Xt & Yt for coordinate)
%  ch1&ch2   : channel names (string)
%  mgate1&2  : manual gates input (log scale)
%  outsw     : output/figure switch (0 or 1);
%
%  Usage:  CycIF_visualgate2D(datatable,'Ch1','Ch2',0,0,1);
%

%% Initialization (define gates) 

temp1 = log(datatable{:,ch1}+5);      %numerial data for gating
temp2 = log(datatable{:,ch2}+5);

if mgate1 ==0
    lowb1 = prctile(temp1,1);
    highb1 = prctile(temp1,99);
else
    lowb1 = mgate1-1;
    highb1 = mgate1+1;
end

if mgate2 ==0
    lowb2 = prctile(temp2,1);
    highb2 = prctile(temp2,99);
else
    lowb2 = mgate2-1;
    highb2 = mgate2+1;
end

intv = 0.01;
[gate1,~,~,~]=finegate(temp1,intv,0,lowb1,highb1);
[gate2,~,~,~]=finegate(temp2,intv,0,lowb2,highb2);

pcells1 = temp1 > gate1;
pcells2 = temp2 > gate2;

newCh1 = strcat(ch1,'p');
newCh2 = strcat(ch2,'p');
newCh1Ch2 = strcat(ch1,ch2,'p');

datatable{:,newCh1}=pcells1;
datatable{:,newCh2}=pcells2;
datatable{:,newCh1Ch2}=pcells1.*pcells2;

%% Output/figure section

if outsw>0

    figure;

%% Plot 1 (gating)
subplot(2,2,1);

dscatter(temp1,temp2);
hold on;

plot([gate1,gate1],[lowb2-1,highb2+2],'--k','LineWidth',2);
plot([lowb1-1,highb1+2],[gate2,gate2],'--k','LineWidth',2);


title(['Double positive=',num2str(mean(pcells1.*pcells2),'%0.3f')]);
xlabel([ch1,':',num2str(gate1,'%0.2f')]);
ylabel([ch2,':',num2str(gate2,'%0.2f')]);

xlim([lowb1-1,highb1+2]);
ylim([lowb2-1,highb2+2]);
hold off;

%% Plot 2 (Density plot for ch1)
ax1=subplot(2,2,3);

CycIF_tumorview(datatable,ch1,1);
caxis([lowb1-0.5 highb1+1.5]);
title([ch1,'+cell=',num2str(mean(pcells1),'%0.3f')]);
xl = xlim;
yl = ylim;

%% Plot 3 (Density plot for ch2)
ax2=subplot(2,2,4);

CycIF_tumorview(datatable,ch2,1);
caxis([lowb2-0.5 highb2+1.5]);
title([ch2,'+cell=',num2str(mean(pcells2),'%0.3f')]);
xlim(xl);
ylim(yl);

%% Plot 4 (Double positive density)
ax3=subplot(2,2,2);

CycIF_tumorview(datatable,newCh1Ch2,3);
title('Double Positive cells');
xlim(xl);
ylim(yl);
colorbar;

linkaxes([ax1,ax2,ax3],'xy');
end


newdatatable = datatable;
pluscells = datatable{:,newCh1Ch2};

return;



