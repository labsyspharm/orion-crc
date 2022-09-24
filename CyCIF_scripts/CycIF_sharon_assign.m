DMSO{1} = horzcat(wellsum_nuc{2,3},wellsum_cyto{2,3});
DMSO{2} = horzcat(wellsum_nuc{2,4},wellsum_cyto{2,4});
DMSO{3} = horzcat(wellsum_nuc{2,5},wellsum_cyto{2,5});
SUN{1} = horzcat(wellsum_nuc{3,3},wellsum_cyto{3,3});
SUN{2} = horzcat(wellsum_nuc{3,4},wellsum_cyto{3,4});
SUN{3} = horzcat(wellsum_nuc{3,5},wellsum_cyto{3,5});
ERO{1} = horzcat(wellsum_nuc{4,3},wellsum_cyto{4,3});
ERO{2} = horzcat(wellsum_nuc{4,4},wellsum_cyto{4,4});
ERO{3} = horzcat(wellsum_nuc{4,5},wellsum_cyto{4,5});

array2csv(DMSO{1},'DMSO1.csv',label1);
array2csv(DMSO{2},'DMSO2.csv',label1);
array2csv(DMSO{3},'DMSO3.csv',label1);
array2csv(SUN{1},'SUN1.csv',label1);
array2csv(SUN{2},'SUN2.csv',label1);
array2csv(SUN{3},'SUN3.csv',label1);
array2csv(ERO{1},'ERO1.csv',label1);
array2csv(ERO{2},'ERO2.csv',label1);
array2csv(ERO{3},'ERO3.csv',label1);
