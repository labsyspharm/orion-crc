data = INTD{4,5};

corrall = zeros(35,35);

for i=1:35
    for j=1:35
    corrall(i,j)=corr(data(:,i),data(:,j));
    end
end
figure, imagesc(corrall);
colormap jet;
colorbar;

