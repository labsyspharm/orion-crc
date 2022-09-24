wellPr=cell(6,10);
wellDb=cell(6,10);
wellDfa=cell(6,10);

for i = 1:6;
    for j=1:10;
        disp([i j]);
        number = length(welldata{i,j}(1,:));
        [wellPr{i,j},wellDb{i,j},wellDfa{i,j}]=normplot5n(welldata{i,j},number);
    end
end


%% all traces heatmap
figure;

for i = 1:6;
    for j=1:10;
        subplot_tight(6,10,(i-1)*10+j,[0.01,0.01]);
        imagesc(welldata{i,j});
        %title(['Well ',num2str(i),'-',num2str(j)])
        %xlabel('Traces');
        %ylabel('Frame');
        axis off;
    end
end

%% all traces plots
figure;

for i = 1:6;
    for j=1:10;
        subplot_tight(6,10,(i-1)*10+j,[0.01,0.01]);
        plot(welldata{i,j});
        %title(['Well ',num2str(i),'-',num2str(j)])
        xlim([0 210]);
        ylim([0 5]);
        text(100,4.5,['Well ',num2str(i),'-',num2str(j)],'FontSize',8);
        axis off;
    end
end

%% Scatter plots

figure;

for i =1:6;
    for j=1:10;
        subplot(6,10,(i-1)*10+j);
        scatter(wellDb{i,j},wellDfa{i,j},20,wellPr{i,j},'fill');
        xlim([0 12]);
        ylim([0.5 1.5]);
    end
end

%% Heatmaps

figure;
x = repmat(1:10,6,1);
y = repmat((1:6)',1,10);

subplot(2,2,1);
imagesc(cellfun(@mean,wellDb));
title('Mean Well DB','FontSize',14);
colorbar;

subplot(2,2,2);
imagesc(cellfun(@mean,wellDfa));
title('Mean well DFA','FontSize',14);
colorbar;

subplot(2,2,3);
imagesc(cellfun(@mean,wellPr));
title('Mean well Period','FontSize',14);
colorbar;

subplot(2,2,4);

posi = cellfun(@(x,y,z)x>6&y<1&z<10,wellDb,wellDfa,wellPr,'UniformOutput',false);
imagesc(cellfun(@sum,posi));
title('Oscillator No.','FontSize',14);
colorbar;
        