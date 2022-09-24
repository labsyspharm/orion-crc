%% Alexnet test1
%  Jerry LIn 2022/04/6
%  Original:
%  https://blogs.mathworks.com/deep-learning/2019/07/24/deep-learning-for-medical-imaging/
%% Load images
allImages = imageDatastore('D:/Orion_CRC_HE_patches/All_patches','IncludeSubfolders',true,'LabelSource','foldernames');
[training_set, validation_set, testing_set] = splitEachLabel(allImages,.7,.1,.2);

%minSetCount = min(allImages.countEachLabel{:,2});
%trainingNumFiles = round(minSetCount/2);
%[training_set, validation_set, testing_set] = splitEachLabel(allImages,trainingNumFiles,'randomize');
            
%% setup net model (googlenet)
net = googlenet;
numClasses = numel(categories(training_set.Labels));
lgraph = layerGraph(net); 
newLearnableLayer = fullyConnectedLayer(numClasses, ...
    'Name','new_fc', ...
    'WeightLearnRateFactor',10, ...
    'BiasLearnRateFactor',10);
lgraph = replaceLayer(lgraph,'loss3-classifier',newLearnableLayer);
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'output',newClassLayer);
figure,plot(lgraph)
categories(training_set.Labels)


%% Alexnet

layersTransfer = net.Layers(1:end-3);
categories(training_set.Labels)
numClasses = numel(categories(training_set.Labels));
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'Name', 'fc','WeightLearnRateFactor',1,'BiasLearnRateFactor',1)
    softmaxLayer('Name', 'softmax')
    classificationLayer('Name', 'classOutput')];

lgraph = layerGraph(layers);
figure,plot(lgraph)

%% Augmented & resize
imageInputSize = [224 224 3];       %googlenet
%imageInputSize = [227 227 3];      %alexnet

augmented_training_set = augmentedImageSource(imageInputSize,training_set);
resized_validation_set = augmentedImageDatastore(imageInputSize,validation_set);
resized_testing_set = augmentedImageDatastore(imageInputSize,testing_set);

%% Set opitions (alexNet)
opts = trainingOptions('sgdm', ...
'MiniBatchSize', 32,... % mini batch size, limited by GPU RAM, default 100 on Titan, 500 on P6000
'InitialLearnRate', 1e-5,... % fixed learning rate
'L2Regularization', 1e-4,... % optimization L2 constraint
'MaxEpochs',10,... % max. epochs for training, default 3
'ExecutionEnvironment', 'gpu',...% environment for training and classification, use a compatible GPU
'ValidationData', resized_validation_set,...
'Plots', 'training-progress');

%% set opitions (googlenet)
options = trainingOptions('sgdm', ...
    'MiniBatchSize',40, ...
    'MaxEpochs',3, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',resized_validation_set, ...
    'ValidationFrequency',100, ...
    'Verbose',false, ...
    'Plots','training-progress');

%% Training & classification
net = trainNetwork(augmented_training_set, lgraph, options);
%net = trainNetwork(augmented_training_set, lgraph, opts);

[predLabels,predScores] = classify(net, resized_testing_set, 'ExecutionEnvironment','gpu');

figure,plotconfusion(testing_set.Labels, predLabels);
PerItemAccuracy = mean(predLabels == testing_set.Labels);
title(['overall per image accuracy ',num2str(round(100*PerItemAccuracy)),'%']);

%% display

test2 = test1(20001:30000);
figure;
idx = randperm(length(test2),90);
im = imtile(test2(idx),'ThumbnailSize',[50,50],'Border',2,'GridSize',[10 9]);
imshow(im)
daspect([1 1 1]);

%% check validation
flag1 = 4;
allcats = categories(training_set.Labels);

mat1 = myconfusionmat(testing_set.Labels, predLabels,false);
allfiles = testing_set.Files;
cats = categories(training_set.Labels);
flag2 = testing_set.Labels == predLabels;
preidx = ismember(testing_set.Labels,cats{flag1});
preidx2 = ismember(preLabels,cats{flag1});

figure('units','normalized','outerposition',[0 0 1 1]);

subplot (1,2,1);

allidx = preidx & flag2;
list1 = 1:length(allidx);
allidx = list1(allidx);

idx = datasample(allidx,42,'replace',true);
im = imtile(allfiles(idx),'ThumbnailSize',[100,100],'Border',2,'GridSize',[7 6]);
imshow(im);
daspect([1 1 1]);
title(strcat('Correct:',cats{flag1}),'Interpreter','none','FontSize',14);

%-------------------------
subplot (1,2,2);

allidx = preidx & ~flag2;
list1 = 1:length(allidx);
allidx = list1(allidx);

idx = datasample(allidx,42,'replace',true);
im = imtile(allfiles(idx),'ThumbnailSize',[100,100],'Border',2,'GridSize',[7 6]);
imshow(im);
daspect([1 1 1]);
title(strcat('Incorrect:',cats{flag1}),'Interpreter','none','FontSize',14);

set(gcf,'color','w');
pre1 = mat1(flag1,flag1) / sum(mat1(:,flag1)) *100;
rec1 = mat1(flag1,flag1) / sum(mat1(flag1,:)) *100;
sgtitle(strcat(allcats{flag1},'(',num2str(pre1,'%0.1f'),'%,',num2str(rec1,'%0.1f'),'%)'),'Fontsize',24);

%% my test1 (shufflenet learning)

%net2 = shufflenet;
allfiles = testing_set.Files;
%label1 = 'Bedlington terrier';
label1 = test1{8,1};
preidx = ismember(predLabels,label1);
list1 = 1:length(predLabels);
allidx = list1(preidx);
tabulate(testing_set.Labels(preidx));
%tabulate(idxK(preidx));

figure('units','normalized','outerposition',[0.5 0 0.5 1]);
idx = datasample(allidx,90,'replace',true);
im = imtile(allfiles(idx),'ThumbnailSize',[50,50],'Border',2,'GridSize',[10 9]);
imshow(im);
daspect([1 1 1]);
title(label1,'FontSize',14);
set(gcf,'color','w');

%% my test2

allfiles = testing_set.Files;
flag1 = 15;
preidx = idxK == flag1;
list1 = 1:length(predLabels);
allidx = list1(preidx);
tabulate(testing_set.Labels(preidx));

figure('units','normalized','outerposition',[0.5 0 0.5 1]);
idx = datasample(allidx,90,'replace',true);
im = imtile(allfiles(idx),'ThumbnailSize',[50,50],'Border',2,'GridSize',[10 9]);
imshow(im);
daspect([1 1 1]);
title(strcat('Cluster',num2str(flag1)),'FontSize',14);
set(gcf,'color','w');

%% check validation
flag1 = 5;
allcats = categories(training_set.Labels);

mat1 = myconfusionmat(testing_set.Labels, predLabels,false);
allfiles = testing_set.Files;
cats = categories(training_set.Labels);
flag2 = testing_set.Labels == predLabels;
preidx = ismember(testing_set.Labels,cats{flag1});
preidx2 = ismember(predLabels,cats{flag1});

figure('units','normalized','outerposition',[0 0 1 1]);

subplot (1,3,1);

allidx = preidx & flag2;
list1 = 1:length(allidx);
allidx = list1(allidx);

idx = datasample(allidx,32,'replace',true);
im = imtile(allfiles(idx),'ThumbnailSize',[100,100],'Border',2,'GridSize',[8 4]);
imshow(im);
daspect([1 1 1]);
title(strcat('True Positive:',num2str(mean(preidx & flag2)*100,'%0.2f'),'%'),'Interpreter','none','FontSize',14);

%-------------------------
subplot (1,3,2);

allidx = preidx & ~flag2;
list1 = 1:length(allidx);
allidx = list1(allidx);

idx = datasample(allidx,32,'replace',true);
im = imtile(allfiles(idx),'ThumbnailSize',[100,100],'Border',2,'GridSize',[8 4]);
imshow(im);
daspect([1 1 1]);
title(strcat('False Negitive:',num2str(mean(preidx & ~flag2)*100,'%0.2f'),'%'),'Interpreter','none','FontSize',14);

set(gcf,'color','w');
pre1 = mat1(flag1,flag1) / sum(mat1(:,flag1)) *100;
rec1 = mat1(flag1,flag1) / sum(mat1(flag1,:)) *100;

%-------------------------
subplot (1,3,3);

allidx = preidx2 & ~flag2;
list1 = 1:length(allidx);
allidx = list1(allidx);

idx = datasample(allidx,32,'replace',true);
im = imtile(allfiles(idx),'ThumbnailSize',[100,100],'Border',2,'GridSize',[8 4]);
imshow(im);
daspect([1 1 1]);
title(strcat('False Positive:',num2str(mean(preidx2 & ~flag2)*100,'%0.2f'),'%'),'Interpreter','none','FontSize',14);

set(gcf,'color','w');
pre1 = mat1(flag1,flag1) / sum(mat1(:,flag1)) *100;
rec1 = mat1(flag1,flag1) / sum(mat1(flag1,:)) *100;

sgtitle(strcat(allcats{flag1},'(',num2str(pre1,'%0.1f'),'%,',num2str(rec1,'%0.1f'),'%)'),'Fontsize',24);


