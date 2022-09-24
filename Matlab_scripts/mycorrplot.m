function h1 = mycorrplot(dataarray,namearray)
%% My function to generate corrplot
%  Jerry Lin 2018/03/01

%% Initialization
no = size(dataarray,2);
nbound = [3,12];

nbins = nbound(1):0.1:nbound(2);
%% plot
h1=figure;
set(h1,'Position',[100 100 1600 900]);
fig1 = tight_subplot(no,no);

for i=1:no
    for j=1:no
        figno = (i-1)*no+j;
        axes(fig1(figno));
        
        if(i==j)
           data1 = dataarray(:,i);
           histogram(log(data1+5),nbins);
           xlim(nbound);
           xl = xlim;
           yl = ylim;
           ylim([yl(1),yl(2)*1.2]);
           DR = prctile(data1,95)-prctile(data1,5);
           text(xl(1)+0.1*(xl(2)-xl(1)),yl(2),['Dynamic Range=',num2str(DR)]);
        end
        
        if(j>i)
            data1=dataarray(:,i);
            data2=dataarray(:,j);
            scatter(log(data1+5),log(data2+5),5,'c','fill');
            box on;
            lsline;
            xl = xlim;
            yl = ylim;
            [r,p] = corr(data1,data2);       
            text(xl(1)+0.1*(xl(2)-xl(1)),yl(1)+(yl(2)-yl(1))*0.9,['r = ' num2str(r,'%0.3f')]);  % Add the value of r to the plot.
            %text(xl(1)+0.1*(xl(2)-xl(1)),(yl(2)-yl(1))*0.8,['p = ' num2str(p,'%0.3f')]) % Add the value of p to the plot.
        end
        
        if(i>j)
            data1=dataarray(:,i);
            data2=dataarray(:,j);
            scatter(data1,data2,5,'b','fill');
            box on;
            lsline;
            xl = xlim;
            yl = ylim;
            [r,p] = corr(data1,data2);       
            text(xl(1)+0.1*(xl(2)-xl(1)),yl(1)+(yl(2)-yl(1))*0.9,['r = ' num2str(r,'%0.3f')]);  % Add the value of r to the plot.
            %text(xl(1)+0.1*(xl(2)-xl(1)),(yl(2)-yl(1))*0.8,['p = ' num2str(p,'%0.3f')]) % Add the value of p to the plot.
        end
        
        if (j>1)
            set(gca,'yticklabels',[]);
        end
        
        if i<no
            set(gca,'xticklabels',[]);
        end
        
        if i==1
            title(namearray{j});
        end
        
        if j==no
            set(gca, 'YAxisLocation', 'right')
            ylabel(namearray{i});
            %set(get(gca,'ylabel'),'rotation',-90)
        end
                
    end
end

return
