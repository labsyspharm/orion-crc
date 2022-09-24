%% Counts tables for all slides (only markers)

tic;
maxL = 200;
allcounts = [];

for s=1:length(slideName)
    disp(strcat('Processing:',slideName{s}));
    data1 = eval(strcat('data',slideName{s}));

    data1.col = round(data1.Xt ./ maxL)+1;
    data1.row = round(data1.Yt ./ maxL)+1;
    data1.frame = round(data1.col+ max(data1.col)*(data1.row-1));

    count1 = varfun(@sum,data1,'GroupingVariables','frame','Inputvariables',labelp);
    if isempty(allcounts)
        allcounts = count1{:,3:end};
    else
        allcounts = vertcat(allcounts,count1{:,3:end});
    end
    eval(strcat('data',slideName{s},'=data1;'));
    toc;
end   

%% --Calculate LDA & plots (markers only, All slides)-----

maxT = 30;
tic;
lda1 = fitlda(allcounts,maxT);
toc;
figure,imagesc(lda1.TopicWordProbabilities);colormap(jet);
title ('Topic Word probabilities');
set(gca,'ytick',1:length(labelp2));
set(gca,'yticklabels',labelp2);
xlabel('Topics');
colorbar;
caxis([0 0.25]);

figure
for topicIdx = 1:maxT
    subplot(5,6,topicIdx)
    temp1 = table;
    temp1.Word = labelp2;
    
    temp1.Count = lda1.TopicWordProbabilities(:,topicIdx);
    wordcloud(temp1,'Word','Count');
    title("Topic: " + topicIdx)
end
toc;
