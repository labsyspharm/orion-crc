function [pluscells,newdatatable,gate1,gate2,allh]=CycIF_visualgate2D(datatable,ch1,ch2,mgate1,mgate2,s1)
%% For visualization & gating CycIF datatable, require CycIF_tumorview
%  Jerry Lin 2018/03/08     New version
%  Jerry Lin 2018/03/19     New version (colormap)
%  Jerry Lin 2019/12/09     New version (differnet color schemes)
%
%  datatable : CycIF table format (need Xt & Yt for coordinate)
%  ch1&ch2   : channel names (string)
%  mgate1&2  : manual gates input (log scale)
%
%  Usage:  CycIF_visualgate2D(datatable,'Ch1','Ch2',0,0);
%

%% Initialization (define gates) 
if nargin < 6
    s1 = 5;
end

if(length(datatable{:,1})>50000)
    datatable = datasample(datatable,50000,'replace',false);
end

temp1 = log(datatable{:,ch1}+5);      %numerial data for gating
temp2 = log(datatable{:,ch2}+5);

[pcells1, gate1, ~,lowb1,highb1]=findgate3(temp1,0,0.05,mgate1);
[pcells2, gate2, ~,lowb2,highb2]=findgate3(temp2,0,0.05,mgate2);


newCh1 = strcat(ch1,'p');
newCh2 = strcat(ch2,'p');
newCh1Ch2 = strcat(ch1,ch2,'p');

datatable{:,newCh1}=pcells1;
datatable{:,newCh2}=pcells2;
datatable{:,newCh1Ch2}=pcells1.*pcells2;

% --define dp group---
datatable.dgroup = zeros(size(datatable,1),1);
datatable.dgroup(pcells1&pcells2) = 1;
datatable.dgroup(pcells1&~pcells2) = 2;
datatable.dgroup(~pcells1&~pcells2) = 3;
datatable.dgroup(~pcells1&pcells2) = 4;

%% Output/figure section

figure('units','normalized','outerposition',[0.5 0 0.5 1]);


%% Plot 1 (gating)
subplot(2,10,1:5);

dscatter(temp1,temp2);
colormap(gca,jet);
hold on;
 
q1 = mean(pcells1 .* pcells2);
q2 = mean(pcells1 .* ~pcells2);
q3 = mean(~pcells1 .* ~pcells2);
q4 = mean(~pcells1 .* pcells2);

foldx = mean(q1/((q1+q2)*(q1+q4)));

title(['Double positive=',num2str(mean(pcells1.*pcells2),'%0.3f'),'(oddR=',num2str(foldx,'%0.2f'),')']);
xlabel([ch1,':',num2str(gate1,'%0.2f')], 'interpreter', 'none');
ylabel([ch2,':',num2str(gate2,'%0.2f')], 'interpreter', 'none');

xlim([lowb1-0.5,highb1+1.5]);
ylim([lowb2-0.5,highb2+1.5]);
%xlim([4 12]);
%ylim([4 12]);
xlims = xlim;
ylims = ylim;

plot([gate1,gate1],ylims,'--k','LineWidth',2);
plot(xlims,[gate2,gate2],'--k','LineWidth',2);

text(xlims(2)*0.9,ylims(2)*0.95,num2str(q1,'%0.2f'),'FontSize',12);
text(xlims(2)*0.9,ylims(1)*1.05,num2str(q2,'%0.2f'),'FontSize',12);
text(xlims(1)*1.05,ylims(1)*1.05,num2str(q3,'%0.2f'),'FontSize',12);
text(xlims(1)*1.05,ylims(2)*0.95,num2str(q4,'%0.2f'),'FontSize',12);

hold off;

%% Plot 2 (Density plot for ch1)
ax1=subplot(2,10,11:15);

h1=CycIF_tumorview(datatable,newCh1,8,1,'g',s1/2);
caxis([lowb1-0.5 highb1+1.5]);
title([ch1,'+cell=',num2str(mean(pcells1),'%0.3f')], 'interpreter', 'none');
xl = xlim;
yl = ylim;

%% Plot 3 (Density plot for ch2)
ax2=subplot(2,10,16:20);

h2=CycIF_tumorview(datatable,newCh2,8,1,'r',s1/2);
caxis([lowb2-0.5 highb2+1.5]);
title([ch2,'+cell=',num2str(mean(pcells2),'%0.3f')], 'interpreter', 'none');
xlim(xl);
ylim(yl);

%% Plot 4 (Double positive dotplot)
ax3=subplot(2,10,6:10);

h3=CycIF_tumorview(datatable,'dgroup',6,1,'r',s1/2);
title('Double Positive group');
xlim(xl);
ylim(yl);
colormap(gca,jet);
colorbar off;
legend({'-/-','-/+','+/-','+/+'});

linkaxes([ax1,ax2,ax3],'xy');


newdatatable = datatable;
pluscells = datatable{:,newCh1Ch2};

allh = [h1,h2,h3];
return;



