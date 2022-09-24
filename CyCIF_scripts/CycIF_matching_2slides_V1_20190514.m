%% Find POI in different slides (RareCyte Picking)
%  Jerry Lin 2019/05/14


%% Initializaiton (select reference points)

TARGET_I = imread('TON3.tif');          % Target image (0.1 Montage)
REF_I = imread('TON2.tif');          % Reference iamge (0.1 Montage)
TARGET_X0 = 35689;                  % ROI position - half frame
TARGET_Y0 = 6427;                   % ROI position - half frame
steps = 13;                     %10 pixels *1.3 = 13 um

cpselect(TARGET_I,REF_I);


%%  Transformation 

mytransform1 = fitgeotrans(movingPoints,fixedPoints,'NonreflectiveSimilarity');
TARGET_Ir=imwarp(TARGET_I,mytransform1,'OutputView',imref2d(size(REF_I)));

figure,imshowpair(REF_I,TARGET_Ir,'falseColor');
TARGET_IX = TARGET_X0:steps:(TARGET_X0+(size(REF_I,2)-1)*steps);
TARGET_IX = repmat(TARGET_IX,size(REF_I,1),1);

TARGET_IY = (TARGET_Y0:steps:(TARGET_Y0+(size(REF_I,1)-1)*steps))';
TARGET_IY = repmat(TARGET_IY,1,size(REF_I,2));

figure;
subplot(2,2,1);imagesc(TARGET_IX);
subplot(2,2,2);imagesc(TARGET_IY);

TARGET_IXr=imwarp(TARGET_IX,mytransform1,'OutputView',imref2d(size(REF_I)),'Interp','nearest');
TARGET_IYr=imwarp(TARGET_IY,mytransform1,'OutputView',imref2d(size(REF_I)),'Interp','nearest');

subplot(2,2,3);imagesc(TARGET_IXr);
subplot(2,2,4);imagesc(TARGET_IYr);

%% Query with Ashlar positions

QueryX = input('Please input query X (in pixel)=');
QueryY = input('Please input query Y (in pixel)=');

ArrayX = round(QueryX/10);
ArrayY = size(TARGET_I,1)-round(QueryY/10);

StageX = TARGET_IXr(ArrayY,ArrayX);
StageY = TARGET_IYr(ArrayY,ArrayX);

disp(strcat('Position X=',num2str(TARGET_IXr(ArrayY,ArrayX))));
disp(strcat('Position Y=',num2str(TARGET_IYr(ArrayY,ArrayX))));

imageX = (StageX-TARGET_X0)/10/1.3;
imageY = (StageY-TARGET_Y0)/10/1.3;

figure('units','normalized','outerposition',[0.5 0.5 0.5 0.5]);
subplot(1,2,1);
imagesc(REF_I);hold on;
scatter(QueryX/10,size(REF_I,1)-QueryY/10,100,'r','fill');
title('Reference');
subplot(1,2,2);
imagesc(TARGET_I);hold on;
scatter(imageX,imageY,100,'r','fill');
title('Target');

