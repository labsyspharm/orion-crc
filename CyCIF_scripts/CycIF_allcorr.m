
fitdata = alldata;

ch_n = length(channels);


for i = 1:ch_n;
    for j=1:ch_n;
        co(i,j)=corr(fitdata(:,i),fitdata(:,j));
    end
end

figure,imagesc(co);
colorbar;
set(gca,'YTick',1:ch_n);
set(gca,'YTickLabel',channelnames(1:ch_n,:));
set(gca,'XAxisLocation','top');
set(gca,'XTick',1:ch_n);
set(gca,'XTickLabel',channelnames(1:ch_n,:));
set(gca,'XTickLabelRotation',45);


colormap('jet');

