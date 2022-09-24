function h1=CycIF_tumorviewTTX(datatable,channel,sw1,sw2,c1,s1)
%% For viewing a specific channel in 'real space', require CycIF data table
%   Jerry Lin 2019/02/27
%   Jerry Lin 2019/03/18  Bug fixed (xlim instability)
%   Jerry Lin 2019/03/27  Bug fixed (xlim/ylim begin points)
%   Jerry Lin 2019/12/07  new function (6: dp group plotting)
%   Jerry Lin 2019/12/09  new function (color option for plot 2);
%   Jerry Lin 2020/05/13  new function (7: none log representation);
%   Jerry Lin 2020/05/16  new function (8: dot plot with density contour);
%   Jerry Lin 2021/08/31  new function (9: colormap with labels on maps)
%  
%  datatable : CycIF table format (need Xt & Yt for coordinate)
%  channel   : channel name (string)
%  sw1       : switch (1: density; 2: positive/negative; 3:Postive Density; 4:digital; 5:digital with % 6:dp group)
%  sw2       : switch 2 (0: no sampling;  1: sampling)
%  c1        : dot color
%  s1        : dot size

%% Initialization

if nargin < 4
    c1 = 'r';
    sw2 = 1;
    s1 = 5;
elseif nargin < 5
    s1 = 5;
    c1 = 'r';
elseif nargin < 6
    s1 = 5;
end

if size(datatable,1)>50000 && sw2==1
    datatable = datasample(datatable,50000,'replace',false);
elseif sw2 >1
    datatable = datasample(datatable,sw2,'replace',false);
else
    datatable = datatable;
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
    if(min(datatable{:,channel})>exp(1))
        h1=scatter(datatable.Xtt,datatable.Ytt,s1,log(datatable{:,channel}),'fill');colormap(jet);colorbar;
    else
        h1=scatter(datatable.Xtt,datatable.Ytt,s1,asinh(double(datatable{:,channel})),'fill');colormap(jet);colorbar;
    end
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    
    xlim([(round(min(datatable.Xtt)/xticksize)-0.5)*xticksize (round(max(datatable.Xtt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Ytt)/yticksize)-0.5)*yticksize (round(max(datatable.Ytt)/yticksize)+0.5)*yticksize]);
    
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(channel, 'interpreter', 'none');
    xlabel('X position');
    ylabel('Y position');
elseif sw1 == 2     % Postive/Negative
    poscells = datatable(datatable{:,channel}==1,:);
    negcells = datatable(datatable{:,channel}==0,:);
    scatter(negcells.Xtt,negcells.Ytt,s1/2,'MarkerEdgeColor',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7]);
    hold on;
    h1=scatter(poscells.Xtt,poscells.Ytt,s1,c1,'fill');
    %legend({'Negative','Positive'});
    legend({'Negative','Positive'},'Location','southwest','Orientation','horizontal')
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    hold off;
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xtt)/xticksize)-0.5)*xticksize (round(max(datatable.Xtt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Ytt)/yticksize)-0.5)*yticksize (round(max(datatable.Ytt)/yticksize)+0.5)*yticksize]);
    
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(strcat(channel,'+'), 'interpreter', 'none');
    xlabel('X position');
    ylabel('Y position');

elseif sw1 == 3                % Postive density plot
    poscells = datatable(datatable{:,channel}==1,:);
    f1=scatter(datatable.Xtt,datatable.Ytt,s1,[0.1 0.1 0.1],'fill');
    f1.MarkerFaceAlpha = 0.2;
    hold on;
    h1=dscatter(poscells.Xtt,poscells.Ytt);colormap(jet);
    %f2.LineWidth = 2;
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    legend({'Negative','Positive'},'Location','southwest','Orientation','horizontal');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xtt)/xticksize)-0.5)*xticksize (round(max(datatable.Xtt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Ytt)/yticksize)-0.5)*yticksize (round(max(datatable.Ytt)/yticksize)+0.5)*yticksize]);
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(strcat(channel,'+,density'), 'interpreter', 'none');
    xlabel('X position');
    ylabel('Y position');
elseif sw1 == 4             % Category representation
    temp1=tabulate(datatable{:,channel});
    h1=scatter(datatable.Xtt,datatable.Ytt,s1,datatable{:,channel},'fill');colormap(jet(size(temp1,1)));colorbar;
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xtt)/xticksize)-0.5)*xticksize (round(max(datatable.Xtt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Ytt)/yticksize)-0.5)*yticksize (round(max(datatable.Ytt)/yticksize)+0.5)*yticksize]);
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(channel, 'interpreter', 'none');
    xlabel('X position');
    ylabel('Y position');
elseif sw1==5               % Catetory representation with %
    temp1=tabulate(datatable{:,channel});
    h1=scatter(datatable.Xtt,datatable.Ytt,s1,datatable{:,channel},'fill');colormap(jet(size(temp1,1)));
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xtt)/xticksize)-0.5)*xticksize (round(max(datatable.Xtt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Ytt)/yticksize)-0.5)*yticksize (round(max(datatable.Ytt)/yticksize)+0.5)*yticksize]);
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(channel, 'interpreter', 'none');
    xlabel('X position');
    ylabel('Y position');
    label2 = cellstr(num2str(temp1(:,3),'%.3g%%'));
    label1 = cellstr(num2str(temp1(:,1),'%g'));
    label3 = cellfun(@(X,Y) strcat(X,'(',Y,')'),label1,label2,'UniformOutput',false);
    if min(temp1(:,1)) > 0
       colorbar('Ticks',1:size(temp1,1),'TickLabels',label3);
    else
       colorbar('Ticks',0:size(temp1,1)-1,'TickLabels',label3);
    end        
elseif sw1==6           %  Quad(+&- combinatory) representation
    temp1=datatable{:,channel};
    subtable = datatable(temp1==3,:);
    scatter(subtable.Xtt,subtable.Ytt,s1,'MarkerEdgeColor',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7]);
    hold on;
    subtable = datatable(temp1==4,:);
    scatter(subtable.Xtt,subtable.Ytt,s1+1,'r','fill');
    hold on;
    subtable = datatable(temp1==2,:);
    scatter(subtable.Xtt,subtable.Ytt,s1+1,'g','fill');
    hold on;
    subtable = datatable(temp1==1,:);
    h1=scatter(subtable.Xtt,subtable.Ytt,s1+2,'y','fill');
    
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
elseif sw1==7           %  non-log digital
    h1=scatter(datatable.Xtt,datatable.Ytt,s1,(datatable{:,channel}),'fill');colormap(jet);colorbar;
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    
    xlim([(round(min(datatable.Xtt)/xticksize)-0.5)*xticksize (round(max(datatable.Xtt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Ytt)/yticksize)-0.5)*yticksize (round(max(datatable.Ytt)/yticksize)+0.5)*yticksize]);
    
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(channel, 'interpreter', 'none');
    xlabel('X position');
    ylabel('Y position');
    pr05 = prctile(datatable{:,channel},1);
    pr95 = prctile(datatable{:,channel},99);
    caxis([pr05 pr95]);
elseif sw1==8                    % positive with density contour
    poscells = datatable(datatable{:,channel}==1,:);
    negcells = datatable(datatable{:,channel}==0,:);
    scatter(negcells.Xtt,negcells.Ytt,s1/2,'MarkerEdgeColor',[0.8 0.8 0.8],'MarkerFaceColor',[0.8 0.8 0.8]);
    hold on;
    h1=scatter(poscells.Xtt,poscells.Ytt,s1,c1,'fill');
    dscatter(poscells.Xtt,poscells.Ytt,'PLOTTYPE','CONTOUR');
    %legend({'Negative','Positive'});
    legend({'Negative','Positive'},'Location','southwest','Orientation','horizontal')
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    hold off;
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xtt)/xticksize)-0.5)*xticksize (round(max(datatable.Xtt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Ytt)/yticksize)-0.5)*yticksize (round(max(datatable.Ytt)/yticksize)+0.5)*yticksize]);
    
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(strcat(channel,'+'), 'interpreter', 'none');
    xlabel('X position');
    ylabel('Y position');    
else                        % Category with text labels
    temp1=tabulate(datatable{:,channel});
    color1 = colormap(lines(size(temp1,1)));
    color1(2:end,:) = color1(1:end-1,:);
    color1(1,:) = [0.8 0.8 0.8];
    %h1=scatter(datatable.Xtt,datatable.Ytt,s1,datatable{:,channel},'fill');colormap(color1);
    for i = 1:size(temp1,1)
        cat1 =temp1(i,1);
        data2 = datatable(datatable{:,channel}==cat1,:);
        color2 = repmat(color1(i,:),size(data2,1),1);
        h1=scatter(data2.Xtt,data2.Ytt,s1,color2,'fill');hold on;
        %text(mean(data2.Xtt),mean(data2.Ytt),num2str(cat1),'FontSize',12,'color',[0.3,0.3,0.3],'FontWeight','Bold');
        %text(mean(data2.Xtt),mean(data2.Ytt),num2str(cat1),'FontSize',12,'color',[0.3,0.3,0.3]);
    end
    set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
    set(gca,'xticklabels',{});
    set(gca,'yticklabels',{});
    xlim([(round(min(datatable.Xtt)/xticksize)-0.5)*xticksize (round(max(datatable.Xtt)/xticksize)+0.5)*xticksize]);
    ylim([(round(min(datatable.Ytt)/yticksize)-0.5)*yticksize (round(max(datatable.Ytt)/yticksize)+0.5)*yticksize]);
    xl = xlim;
    yl = ylim;
    set(gca,'xtick',0:xticksize:xl(2));
    set(gca,'ytick',0:yticksize:yl(2));
    grid on;
    title(channel, 'interpreter', 'none');
    xlabel('X position');
    ylabel('Y position');    
end

return;    