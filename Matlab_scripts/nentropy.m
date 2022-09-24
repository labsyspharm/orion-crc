function ne = nentropy(data1,method)

%% normalized entropy (from wentropy)
% data1: array of data
% method:  cell array (method);

%% initilization


ne =wentropy(data1,method) / log(size(data1,1));

return


