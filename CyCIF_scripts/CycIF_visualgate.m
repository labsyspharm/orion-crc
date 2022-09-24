function [positivecells,gate]=CycIF_visualgate(datatable,channel,mgate)
%% For visualization & gating CycIF datatable, require CycIF_tumorview
%  Jerry Lin 2018/11/27
%            2019/03/18 Bug fixed
%
%  datatable : CycIF table format (need Xt & Yt for coordinate)
%  channel   : channel name (string)
%  mgate     : manual gate input (log scale)

%% Initialization 
temp2 = log(datatable{:,channel});      %numerial data for gating

if size(datatable,1)>50000
    datatable = datasample(datatable,50000,'replace',false);
end
temp1 = log(datatable{:,channel});

%set(gcf,'Position',[962 42 958 954]);
figure('units','normalized','outerposition',[0.5 0 0.5 1]);

%% Plot 1 (gating)
subplot(2,10,1:4.2);

[pluscells2, gate, ~,lowb,highb]=findgate3(temp1,1,0.05,mgate);
positivecells = temp2> exp(gate);

title (strcat({'Gating '},channel), 'interpreter', 'none');
newchannel = strcat(channel,'p');
datatable{:,newchannel}=pluscells2;

%% Plot 2 (Density plot)
ax(1)=subplot(2,10,6:10);
CycIF_tumorview(datatable,channel,1);
%caxis([lowb highb+1.5]);
title('Digital Representation (log)');
xl = xlim;
yl = ylim;

colormap(gca,gray);
set(gca,'color','k');
%caxis([lowb+2,highb]);

% grid on;
%colorbar('southoutside');

colorbar off;
%% Plot 3 (Postivie/Negative view)
ax(2)=subplot(2,10,11:15);
CycIF_tumorview(datatable,newchannel,2);

title('Positive cells');

xlim(xl);
ylim(yl);

lgd = legend;
lgd.Orientation = 'vertical';
lgd.Location = 'southeast';

%% Plot 4 (positive density)
ax(3)=subplot(2,10,16:20);
CycIF_tumorview(datatable,newchannel,11);
title('Positive density');
xlim(xl);
ylim(yl);

colormap(gca,redbluecmap);
%colorbar;
legend off;

linkaxes(ax,'xy');
return;



