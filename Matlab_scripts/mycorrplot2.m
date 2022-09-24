function h1 = mycorrplot2(dataarray,namearray)
%% My function to generate corrplot
%  Jerry Lin 2018/03/01

%% Initialization
no = size(dataarray,2);
nbound = [3,11];
samplesize = 2000;
sampleno = 100;
r = zeros(sampleno,1);
nbins = nbound(1):0.1:nbound(2);

%% Filter zeros
flag1 = prod(dataarray,2);
dataarray = dataarray(flag1>0,:);

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
           bincounts = histc(log(data1+5),nbins);
           plot(nbins,bincounts,'r','LineWidth',1);
           xlim(nbound);
           xl = xlim;
           yl = ylim;
           ylim([yl(1),yl(2)*1.2]);
           DR = prctile(data1,99)-prctile(data1,1);
           text(xl(1)+0.1*(xl(2)-xl(1)),yl(2),['Dynamic Range=',num2str(DR)]);
        end
        
        if(j>i)
            tempdata = datasample(dataarray,samplesize);
            data1=tempdata(:,i);
            data2=tempdata(:,j);
            scatter(log(data1+5),log(data2+5),5,'c','fill');
            box on;
            lsline;
            xl = xlim;
            yl = ylim;
            for s=1:sampleno
                tempdata = datasample(dataarray,samplesize);
                data1=log(tempdata(:,i)+5);
                data2=log(tempdata(:,j)+5);
                r(s) = corr(data1,data2);
            end;
            text(xl(1)+0.1*(xl(2)-xl(1)),yl(1)+(yl(2)-yl(1))*0.9,['r = ' num2str(mean(r),'%0.3f'),'+/-',num2str(std(r),'%0.3f')]);  % Add the value of r to the plot.
            %text(xl(1)+0.1*(xl(2)-xl(1)),(yl(2)-yl(1))*0.8,['p = ' num2str(p,'%0.3f')]) % Add the value of p to the plot.
        end
        
        if(i>j)
            tempdata = datasample(dataarray,samplesize);
            data1=tempdata(:,i);
            data2=tempdata(:,j);
            scatter(data1,data2,5,'b','fill');
            box on;
            lsline;
            xl = xlim;
            yl = ylim;
            for s=1:sampleno
                tempdata = datasample(dataarray,samplesize);
                data1=tempdata(:,i);
                data2=tempdata(:,j);
                r(s) = corr(data1,data2);
            end;
            text(xl(1)+0.1*(xl(2)-xl(1)),yl(1)+(yl(2)-yl(1))*0.9,['r = ' num2str(mean(r),'%0.3f'),'+/-',num2str(std(r),'%0.3f')]);  % Add the value of r to the plot.
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
