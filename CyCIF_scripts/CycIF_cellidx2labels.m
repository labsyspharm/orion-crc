function CycIF_cellidx2labels(cell_idx,labels)

temp1 = dec2bin(cell_idx);
temp1 = temp1';
temp1 = str2num(temp1);
temp1 = temp1>0;
labels(temp1)

end
