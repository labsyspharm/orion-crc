%% CycIF Mario lookup generate
% 
%  Generate new array from randomized plate


%% Initilize value


for i=1:60
    Lookup{i,4}=wellsum_nuc{Lookup{i,2},Lookup{i,3}};
end
