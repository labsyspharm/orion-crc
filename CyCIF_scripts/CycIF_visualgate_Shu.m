function [pluscells,gate,f1]=CycIF_visualgate_Shu(datatable,channel,FDR,K)
%% For visualization & gating CycIF datatable, require CycIF_tumorview & findcutoff (Shu)
%  Jerry Lin 2017/12/01
%
%  datatable : CycIF table format (need Xt & Yt for coordinate)
%  channel   : channel name (string)
%  FDR       : FDR for inputs in findcutoff (Shu);

%% Initialization 

%temp1 = log(datatable{:,channel});      %numerial data for gating

temp2 = log(datatable{:,channel});      %numerial data for gating

if size(datatable,1)>50000
    datatable = datasample(datatable,50000,'replace',false);
end
temp1 = log(datatable{:,channel});

f1=figure('units','normalized','outerposition',[0.5 0 0.5 1]);
%set(gcf,'Position',[962 42 958 954]);

%% Plot 1 (gating)
subplot(2,10,1:4);

[~, ~, ~,lowb,highb]=findgate3(temp1,0,0.05,0);
[gate, pluscells]=CycIF_findcutoff(temp1,2,K,FDR);
title (strcat({'GMM Gating '},channel));
newchannel = strcat(channel,'p');
datatable{:,newchannel}=pluscells;
pluscells = temp2 > exp(gate);
xlim([lowb-0.5 highb+1]);

%% Plot 2 (Density plot)
ha(1)=subplot(2,10,5.5:10);
CycIF_tumorview(datatable,channel,1,1,'r');
caxis([lowb highb+1.5]);
title('Digital Representation (log)');
xl = xlim;
yl = ylim;
%set(gca,'xtick',0:2*416:xl(2));
%set(gca,'ytick',0:2*351:yl(2));
colormap(gca,jet);
%grid on;

%% Plot 3 (Postivie/Negative view)
ha(2)=subplot(2,10,11:14.5);
CycIF_tumorview(datatable,newchannel,2,1,'r');
title('Positive cells');
set(gca,'xtick',0:2*416:xl(2));
set(gca,'ytick',0:2*351:yl(2));
xlim(xl);
ylim(yl);
grid on;
lgd = legend;
lgd.Orientation = 'vertical';
lgd.Location = 'southeast';

%% Plot 4 (positive density)
ha(3)=subplot(2,10,15.5:20);
CycIF_tumorview(datatable,newchannel,3,1,'r');
title('Positive density');
xlim(xl);
ylim(yl);
%set(gca,'xtick',0:2*416:xl(2));
%set(gca,'ytick',0:2*351:yl(2));
%grid on;
colormap(gca,redbluecmap);
colorbar;
legend off;

linkaxes(ha,'xy');
return;



