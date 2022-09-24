%%  CycIF_UINT16
% Convert all data to UINT16
% 2021/08/12 Jerry Lin
% Need SlideName cell array

for i=1:length(slideName)
disp(strcat('Processing:',slideName{i}));
data1 = eval(strcat('data',slideName{i}));
data1{:,:}=uint16(data1{:,:});
eval(strcat('data',slideName{i},'=data1;'));
end

clear data1;
