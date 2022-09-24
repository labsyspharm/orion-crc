function CycIF_tumorview2(datatable,channel,sw1,dotsize)
%% For viewing a specific channel in 'real space', require CycIF data table
%  Jerry Lin 2019/02/27
%   Jerry Lin 2019/03/18  Bug fixed (xlim instability)
%   Jerry Lin 2019/03/27  Bug fixed (xlim/ylim begin points)
%  
%  datatable : CycIF table format (need Xt & Yt for coordinate)
%  channel   : channel name (string)
%  sw1       : switch (1: density; 2: positive/negative; 3:Postive Density; 4:digital)


%% Initialization

if(length(datatable.Xt)>50000)
    datatable = datasample(datatable,50000);
end

if max(datatable.X) < 416
    xticksize = 416;
    yticksize = 351;
elseif max(datatable.X) < 416*2
    xticksize = 416*2;
    yticksize = 351*2;
else
    xticksize = 416*4;
    yticksize = 351*4;
end    

%% Plot
if sw1 == 1         % Color/digital representation
    scatter(datatable.Xt,datatable.Yt,4,log(datatable{:,channel}),'fill');colormap(jet);colorbar;
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    
    xlim([(round(min(datatable.Xt)/xticksize)-0.5)*xticksize (round(max(datatable.Xt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Yt)/yticksize)-0.5)*yticksize (round(max(datatable.Yt)/yticksize)+0.5)*yticksize]);
    
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(channel);
    xlabel('X position');
    ylabel('Y position');
elseif sw1 == 2     % Postive/Negative
    poscells = datatable(datatable{:,channel}==1,:);
    negcells = datatable(datatable{:,channel}==0,:);
    scatter(negcells.Xt,negcells.Yt,dotsize,'k','fill');
    hold on;
    scatter(poscells.Xt,poscells.Yt,dotsize,'r','fill');
    %legend({'Negative','Positive'});
    legend({'Negative','Positive'},'Location','southwest','Orientation','horizontal')
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    hold off;
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xt)/xticksize)-0.5)*xticksize (round(max(datatable.Xt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Yt)/yticksize)-0.5)*yticksize (round(max(datatable.Yt)/yticksize)+0.5)*yticksize]);
    
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(strcat(channel,'+'));
    xlabel('X position');
    ylabel('Y position');

elseif sw1 == 3                % Postive density plot
    poscells = datatable(datatable{:,channel}==1,:);
    f1=scatter(datatable.Xt,datatable.Yt,dotsize,[0.1 0.1 0.1],'fill');
    f1.MarkerFaceAlpha = 0.2;
    hold on;
    dscatter(poscells.Xt,poscells.Yt);colormap(jet);
    %f2.LineWidth = 2;
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    legend({'Negative','Positive'},'Location','southwest','Orientation','horizontal');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xt)/xticksize)-0.5)*xticksize (round(max(datatable.Xt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Yt)/yticksize)-0.5)*yticksize (round(max(datatable.Yt)/yticksize)+0.5)*yticksize]);
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(strcat(channel,'+,density'));
    xlabel('X position');
    ylabel('Y position');
else
    temp1=tabulate(datatable{:,channel});
    scatter(datatable.Xt,datatable.Yt,dotsize,datatable{:,channel},'fill');colormap(jet(size(temp1,1)));colorbar;
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xt)/xticksize)-0.5)*xticksize (round(max(datatable.Xt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Yt)/yticksize)-0.5)*yticksize (round(max(datatable.Yt)/yticksize)+0.5)*yticksize]);
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(channel);
    xlabel('X position');
    ylabel('Y position');
end

    