%Name: Paresh Kamble
%E-mail: kamble.paresh@gmail.com
clc;
clear all;
close all;

F = imread('C:\Users\JLin\Desktop\New folder\B - 02(fld 01 wv DAPI - DAPI).tif');
S = imread('C:\Users\JLin\Desktop\New folder\B - 02(fld 02 wv DAPI - DAPI).tif');

F = im2double(F);
S = im2double(S);

[rows cols] = size(F);

Tmp = [];
%zeros(rows, cols*2);
temp = 0;
S1 = [];
k = 0; 

for j = 1:5
    for i = 1:rows
        S1(i,j) = S(i,j);
    end
end

for k = 0:cols-5% to prevent j to go beyond boundaries.
    for j = 1:5
        F1(:,j) = F(:,k+j);
    end
    temp = corr2(F1,S1);
    Tmp = [Tmp temp]; % Tmp keeps growing, forming a matrix of 1*cols
    temp = 0;
end
% 

[Min_value, Index] = max(Tmp);% .

n_cols = Index + cols - 1;% New column of output image.

Opimg = [];
for i = 1:rows
    for j = 1:Index-1
        Opimg(i,j) = F(i,j);% First image is pasted till Index.
    end
    for k = Index:n_cols
        Opimg(i,k) = S(i,k-Index+1);%Second image is pasted after Index.
    end    
end

[r_Opimg c_Opimg] = size(Opimg);

figure,
subplot(1,3,1);
imshow(F);axis ([1 c_Opimg 1 c_Opimg])
title('First Image');

subplot(1,3,2);
imshow(S);axis ([1 c_Opimg 1 c_Opimg])
title('Second Image');

subplot(1,3,3);
imshow(Opimg);axis ([1 c_Opimg 1 c_Opimg])
title('Stitched Image');

% End of Code