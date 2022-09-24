%% import tracking data (for JY's PIP sensor)
%  and plot CFP-total, YPF-Gem, REP-PIP & togeter
% 

%  2015/12/25

%% Initialization

well = '002010';

filename1 = strcat('F:\20160218-PIP-BJ5\output.total-',well,'.csv');
filename2 = strcat('F:\20160218-PIP-BJ5\output.cfpmean-',well,'.csv');
filename3 = strcat('F:\20160218-PIP-BJ5\output.rfpmean-',well,'.csv');

%% Import data files

total = importfile1(filename1,1,inf);
yfpmean = importfile1(filename2,1,inf);
rfpmean = importfile1(filename3,1,inf);

%% plot

arraysize = size(total,1);
timepoint = size(total,2);

for i =1:4:arraysize
    FigHandle=figure('Position',[1,1,1024,768]);
    for j = 1:4;
        
        current = i+(j-1);
        disp (current);
        if(current <= arraysize)
            subplot(4,4,(j-1)*4+1);
            plot(smooth(total(current,:),4),'b','LineWidth',2);
            xlim([1,timepoint]);
            
            title (['CFP ',num2str(current)]);

            subplot(4,4,(j-1)*4+2);
            plot(yfpmean(current,:),'g','LineWidth',2);
            title (['YFP ',num2str(current)]);
            xlim([1,timepoint]);
            
            subplot(4,4,(j-1)*4+3);
            plot(rfpmean(current,:),'r','LineWidth',2);
            title (['RFP ',num2str(current)]);
            xlim([1,timepoint]);
            
            subplot(4,4,(j-1)*4+4);
            maxv = max(yfpmean(current,:));
            minv = min(yfpmean(current,:));
            
            plot(smooth((yfpmean(current,:)-minv)/(maxv-minv)),'g','LineWidth',2);
            xlim([1,timepoint]);

            hold on;
            maxv = max(rfpmean(current,:));
            minv = min(rfpmean(current,:));
            plot(smooth((rfpmean(current,:)-minv)/(maxv-minv)),'r','LineWidth',2);
            
            maxv = max(total(current,:));
            minv = min(total(current,:));
            plot(smooth((total(current,:)-minv)/(maxv-minv)),'b','LineWidth',1);

            ylim([0 1]);
            title (['ALL ',num2str(current)]);
            hold off;
        end
    end
end

            
            
        